require File.dirname(__FILE__) + '/../test_helper'
class CachingTest < ActionController::IntegrationTest
  fixtures :contents, :users, :sections, :assigned_sections, :sites

  def setup
    prepare_for_caching!
  end

  #def test_should_not_expire_feeds_and_sections_on_new_unpublished_articles
  #  visitor = visit
  #  writer  = login_as :quentin
  #  
  #  visit_sections_and_feeds_with visitor
  #
  #  assert_no_difference Article, :count do
  #    assert_difference Article::Draft, :count do
  #      writer.create :title => 'This is a new article & title', :body => 'this is a new article body', 
  #        :sections => [sections(:home)], :submit => :draft
  #    end
  #  end
  #  
  #  assert_cached section_url_for(:home)
  #  assert_cached section_url_for(:about)
  #  assert_cached feed_url_for(:home)
  #  assert_cached feed_url_for(:about)
  #end

  def test_should_expire_necessary_feeds_and_sections_when_publishing_article
    visitor = visit
    writer  = login_as :quentin
    
    visit_sections_and_feeds_with visitor

    assert_difference Article, :count do
      assert_expires_pages section_url_for(:home),
                           feed_url_for(:home) do
        writer.create :title => 'This is a new article & title', :body => 'this is a new article body', :sections => [sections(:home)], :published_at => Time.now
      end
    end
    
    assert_cached section_url_for(:about)
    assert_cached feed_url_for(:about)
  end

  def test_should_expire_feeds_and_sections_when_publishing_article
    visitor = visit
    writer  = login_as :quentin
    
    visit_sections_and_feeds_with visitor

    assert_difference Article, :count do
      assert_expires_pages section_url_for(:home), section_url_for(:about),
                           feed_url_for(:home),    feed_url_for(:about) do
        writer.create :title => 'This is a new article & title', :body => 'this is a new article body', :sections => [sections(:home), sections(:about)], :published_at => Time.now
      end
    end
  end

  def test_should_expire_articles_after_editing
    visitor = visit
    writer  = login_as :quentin
    
    assert_caches_page contents(:welcome).full_permalink do
      visitor.read contents(:welcome)
    end

    assert_caches_page feed_url_for(:home) do
      visitor.syndicate sections(:home)
    end

    assert_expires_pages contents(:welcome).full_permalink, 
                         feed_url_for(:home) do
      writer.revise contents(:welcome), 'new welcome description'
    end
  end

  def test_should_cache_and_expire_overview_feed_on_edited_article
    rss     = visit
    writer  = login_as :quentin

    assert_caches_page overview_url(:only_path => true, :skip_relative_url_root => true) do
      rss.get_with_basic 'admin/overview.xml', :login => :quentin
    end

    assert_expires_page overview_url(:only_path => true, :skip_relative_url_root => true) do
      writer.revise contents(:welcome), 'new welcome description'
    end
  end

  def test_should_not_expire_cache_on_new_comment
    visitor = visit
    assert_caches_page contents(:welcome).full_permalink do
      visitor.read contents(:welcome)
    end
    
    visitor.comment_on contents(:welcome), :author => 'bob', :body => 'what a wonderful post.'
    
    assert_cached contents(:welcome).full_permalink
  end

  def test_should_expire_cache_when_comment_is_approved
    visitor = visit
    assert_caches_page contents(:welcome).full_permalink do
      visitor.read contents(:welcome)
    end

    login_as :quentin do |writer|
      writer.approve_comment contents(:unwelcome_comment)
      assert contents(:unwelcome_comment).reload.approved?
    end

    assert_not_cached contents(:welcome).full_permalink
  end

  def test_should_expire_cache_when_comment_is_unapproved
    visitor = visit
    assert_caches_page contents(:welcome).full_permalink do
      visitor.read contents(:welcome)
    end

    login_as :quentin do |writer|
      writer.unapprove_comment contents(:welcome_comment)
      assert !contents(:welcome_comment).reload.approved?
    end

    assert_not_cached contents(:welcome).full_permalink
  end

  def test_should_not_cache_bad_urls
    visitor = visit
    pages   = ['/about/blah', '/foo/bar', '2006/1/2/fasd']
    assert_expires_pages *pages do
      pages.each { |p| visitor.get p }
    end
  end

  protected
    def visit_sections_and_feeds_with(visitor)
      assert_caches_page section_url_for(:home) do
        visitor.read sections(:home)
      end

      assert_caches_page section_url_for(:about) do
        visitor.read sections(:about)
      end

      assert_caches_page feed_url_for(:home) do
        visitor.syndicate sections(:home)
      end

      assert_caches_page feed_url_for(:about) do
        visitor.syndicate sections(:about)
      end
    end
end