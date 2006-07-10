# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 32) do

  create_table "assigned_sections", :force => true do |t|
    t.column "article_id", :integer
    t.column "section_id", :integer
    t.column "position",   :integer, :default => 1
  end

  create_table "attachments", :force => true do |t|
    t.column "type",            :string,  :limit => 15
    t.column "content_type",    :string,  :limit => 100
    t.column "filename",        :string
    t.column "path",            :string
    t.column "db_file_id",      :integer
    t.column "parent_id",       :integer
    t.column "size",            :integer
    t.column "width",           :integer
    t.column "height",          :integer
    t.column "attachable_id",   :integer
    t.column "attachable_type", :string,  :limit => 20
    t.column "site_id",         :integer
  end

  create_table "cached_pages", :force => true do |t|
    t.column "url",        :string
    t.column "references", :text
    t.column "updated_at", :datetime
  end

  create_table "content_versions", :force => true do |t|
    t.column "content_id",         :integer
    t.column "version",            :integer
    t.column "article_id",         :integer
    t.column "user_id",            :integer
    t.column "title",              :string
    t.column "permalink",          :string
    t.column "excerpt",            :text
    t.column "body",               :text
    t.column "excerpt_html",       :text
    t.column "body_html",          :text
    t.column "created_at",         :datetime
    t.column "updated_at",         :datetime
    t.column "published_at",       :datetime
    t.column "author",             :string,   :limit => 100
    t.column "author_url",         :string
    t.column "author_email",       :string
    t.column "author_ip",          :string,   :limit => 100
    t.column "comments_count",     :integer,                 :default => 0
    t.column "filters",            :text
    t.column "updater_id",         :integer
    t.column "versioned_type",     :string,   :limit => 20
    t.column "site_id",            :integer
    t.column "approved",           :boolean,                 :default => false
    t.column "expire_comments_at", :datetime
  end

  create_table "contents", :force => true do |t|
    t.column "article_id",         :integer
    t.column "user_id",            :integer
    t.column "title",              :string
    t.column "permalink",          :string
    t.column "excerpt",            :text
    t.column "body",               :text
    t.column "excerpt_html",       :text
    t.column "body_html",          :text
    t.column "created_at",         :datetime
    t.column "updated_at",         :datetime
    t.column "published_at",       :datetime
    t.column "type",               :string,   :limit => 20
    t.column "author",             :string,   :limit => 100
    t.column "author_url",         :string
    t.column "author_email",       :string
    t.column "author_ip",          :string,   :limit => 100
    t.column "comments_count",     :integer,                 :default => 0
    t.column "filters",            :text
    t.column "version",            :integer
    t.column "updater_id",         :integer
    t.column "site_id",            :integer
    t.column "approved",           :boolean,                 :default => false
    t.column "expire_comments_at", :datetime
  end

  create_table "db_files", :force => true do |t|
    t.column "data", :binary
  end

  create_table "events", :force => true do |t|
    t.column "mode",       :string
    t.column "article_id", :integer
    t.column "title",      :text
    t.column "body",       :text
    t.column "created_at", :datetime
    t.column "user_id",    :integer
    t.column "author",     :string,   :limit => 100
    t.column "comment_id", :integer
    t.column "site_id",    :integer
  end

  create_table "sections", :force => true do |t|
    t.column "name",                :string
    t.column "show_paged_articles", :boolean, :default => false
    t.column "articles_per_page",   :integer, :default => 15
    t.column "layout",              :string
    t.column "template",            :string
    t.column "site_id",             :integer
  end

  create_table "sessions", :force => true do |t|
    t.column "session_id", :string
    t.column "data",       :text
    t.column "updated_at", :datetime
  end

  add_index "sessions", ["session_id"], :name => "sessions_session_id_index"

  create_table "sites", :force => true do |t|
    t.column "title",             :string
    t.column "subtitle",          :string
    t.column "email",             :string
    t.column "ping_urls",         :text
    t.column "filters",           :text
    t.column "articles_per_page", :integer,                :default => 15
    t.column "host",              :string
    t.column "akismet_key",       :string,  :limit => 100
    t.column "akismet_url",       :string
    t.column "accept_comments",   :boolean
    t.column "approve_comments",  :boolean
    t.column "comment_age",       :integer
    t.column "timezone",          :string
  end

  create_table "users", :force => true do |t|
    t.column "login",            :string,   :limit => 40
    t.column "email",            :string,   :limit => 100
    t.column "crypted_password", :string,   :limit => 40
    t.column "salt",             :string,   :limit => 40
    t.column "activation_code",  :string,   :limit => 40
    t.column "activated_at",     :datetime
    t.column "created_at",       :datetime
    t.column "updated_at",       :datetime
    t.column "filters",          :text
  end

end
