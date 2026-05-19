authors = [
  { name: "Maya Stone", email: "maya@example.test", editor: true, location: "Prague", website: "https://example.test/maya", bio: "Editor focused on database tools and Rails workflows." },
  { name: "Jon Bell", email: "jon@example.test", editor: true, location: "Berlin", website: "https://example.test/jon", bio: "Writes about product engineering and release habits." },
  { name: "Iris Novak", email: "iris@example.test", editor: false, location: "Brno", website: "https://example.test/iris", bio: "Backend developer documenting practical debugging stories." },
  { name: "Leo Carter", email: "leo@example.test", editor: false, location: "London", website: "https://example.test/leo", bio: "Maintains small teams' internal Rails applications." },
  { name: "Nina Park", email: "nina@example.test", editor: true, location: "Seoul", website: "https://example.test/nina", bio: "Explores how teams keep admin tooling understandable." },
  { name: "Omar Ruiz", email: "omar@example.test", editor: false, location: "Madrid", website: "https://example.test/omar", bio: "Enjoys turning support lessons into better documentation." },
  { name: "Petra Klein", email: "petra@example.test", editor: false, location: "Vienna", website: "https://example.test/petra", bio: "Writes about data quality and migration planning." },
  { name: "Sam Reed", email: "sam@example.test", editor: true, location: "Dublin", website: "https://example.test/sam", bio: "Covers testing, observability, and small operational wins." }
]

authors_by_email = authors.each_with_object({}) do |attributes, collection|
  profile_attributes = attributes.slice(:location, :website, :bio)
  author_attributes = attributes.except(:location, :website, :bio)
  author = BlogAuthor.find_or_initialize_by(email: author_attributes[:email])
  author.update!(author_attributes)

  profile = BlogAuthorProfile.find_or_initialize_by(blog_author: author)
  profile.update!(profile_attributes)

  collection[author.email] = author
end

categories = [
  { name: "Rails", slug: "rails", description: "Notes about Rails applications, engines, and conventions." },
  { name: "Databases", slug: "databases", description: "Schema design, migrations, and data maintenance." },
  { name: "Operations", slug: "operations", description: "Keeping production systems understandable and healthy." },
  { name: "Testing", slug: "testing", description: "Fast feedback and reliable test data." },
  { name: "Product", slug: "product", description: "Building admin tools that fit the user's work." },
  { name: "Security", slug: "security", description: "Access, auditability, and safer defaults." },
  { name: "Design", slug: "design", description: "Readable interfaces for dense data." }
]

categories_by_slug = categories.each_with_object({}) do |attributes, collection|
  category = BlogCategory.find_or_initialize_by(slug: attributes[:slug])
  category.update!(attributes)
  collection[category.slug] = category
end

tags = [
  { name: "Active Record", slug: "active-record" },
  { name: "Engines", slug: "engines" },
  { name: "Admin UI", slug: "admin-ui" },
  { name: "Migrations", slug: "migrations" },
  { name: "SQLite", slug: "sqlite" },
  { name: "PostgreSQL", slug: "postgresql" },
  { name: "Fixtures", slug: "fixtures" },
  { name: "Seeds", slug: "seeds" },
  { name: "Accessibility", slug: "accessibility" },
  { name: "Performance", slug: "performance" }
]

tags_by_slug = tags.each_with_object({}) do |attributes, collection|
  tag = BlogTag.find_or_initialize_by(slug: attributes[:slug])
  tag.update!(attributes)
  collection[tag.slug] = tag
end

posts = [
  { title: "Shipping a Rails Engine With Confidence", slug: "shipping-a-rails-engine-with-confidence", author: "maya@example.test", category: "rails", views_count: 412, published: true, published_at: "2026-04-01 09:00", body: "A checklist for preparing a small Rails engine before the first public release." },
  { title: "When Seeds Are Better Than Fixtures", slug: "when-seeds-are-better-than-fixtures", author: "sam@example.test", category: "testing", views_count: 268, published: true, published_at: "2026-04-03 11:30", body: "Fixtures are great for tests, while seeds are better for a local demo database." },
  { title: "Designing Tables People Can Browse", slug: "designing-tables-people-can-browse", author: "nina@example.test", category: "design", views_count: 351, published: true, published_at: "2026-04-05 14:15", body: "Dense admin screens work best when common actions and status are easy to scan." },
  { title: "Reading Migration History Like a Story", slug: "reading-migration-history-like-a-story", author: "petra@example.test", category: "databases", views_count: 193, published: true, published_at: "2026-04-07 08:45", body: "Good migration names help future maintainers understand how a schema arrived here." },
  { title: "Small Audit Trails for Internal Tools", slug: "small-audit-trails-for-internal-tools", author: "jon@example.test", category: "security", views_count: 229, published: true, published_at: "2026-04-09 16:00", body: "Even lightweight audit data can make admin changes easier to trust." },
  { title: "A Practical SQLite Development Setup", slug: "a-practical-sqlite-development-setup", author: "leo@example.test", category: "databases", views_count: 318, published: true, published_at: "2026-04-11 10:20", body: "SQLite remains a productive default for local demos and small dummy apps." },
  { title: "Making Empty States Useful", slug: "making-empty-states-useful", author: "nina@example.test", category: "product", views_count: 144, published: true, published_at: "2026-04-13 12:00", body: "A helpful empty state tells users what the table represents and what to do next." },
  { title: "The Case for Boring Test Data", slug: "the-case-for-boring-test-data", author: "iris@example.test", category: "testing", views_count: 187, published: true, published_at: "2026-04-15 09:40", body: "Predictable test data makes failures easier to read and reproduce." },
  { title: "Index Pages That Respect Operators", slug: "index-pages-that-respect-operators", author: "omar@example.test", category: "operations", views_count: 276, published: true, published_at: "2026-04-18 15:10", body: "Operational screens should make the next safe action obvious." },
  { title: "Preparing Demo Data for Review", slug: "preparing-demo-data-for-review", author: "maya@example.test", category: "product", views_count: 202, published: true, published_at: "2026-04-21 13:25", body: "Demo data should show relationships, edge cases, and normal usage in one pass." },
  { title: "Documenting Foreign Keys in Dummy Apps", slug: "documenting-foreign-keys-in-dummy-apps", author: "petra@example.test", category: "rails", views_count: 116, published: false, published_at: nil, body: "Dummy apps can model real relationships without leaking those tables into host apps." },
  { title: "Keeping Admin Screens Fast Enough", slug: "keeping-admin-screens-fast-enough", author: "sam@example.test", category: "operations", views_count: 334, published: true, published_at: "2026-04-24 10:05", body: "Pagination, targeted queries, and simple indexes often solve the first round of slowness." }
]

posts_by_slug = posts.each_with_object({}) do |attributes, collection|
  post = BlogPost.find_or_initialize_by(slug: attributes[:slug])
  post.update!(
    blog_author: authors_by_email.fetch(attributes[:author]),
    blog_category: categories_by_slug.fetch(attributes[:category]),
    title: attributes[:title],
    body: attributes[:body],
    views_count: attributes[:views_count],
    published: attributes[:published],
    published_at: attributes[:published_at] && Time.zone.parse(attributes[:published_at])
  )
  collection[post.slug] = post
end

comments = [
  { post: "shipping-a-rails-engine-with-confidence", author: "iris@example.test", approved: true, body: "This is the kind of release checklist I wish every small engine had." },
  { post: "shipping-a-rails-engine-with-confidence", author: "leo@example.test", approved: true, body: "The dummy app reminder saved me from missing a broken route." },
  { post: "when-seeds-are-better-than-fixtures", author: "maya@example.test", approved: true, body: "Keeping fixtures out of demo setup makes the boundary much clearer." },
  { post: "when-seeds-are-better-than-fixtures", author: "petra@example.test", approved: true, body: "I like that the examples stay deterministic without depending on Faker." },
  { post: "designing-tables-people-can-browse", author: "jon@example.test", approved: true, body: "The scan-first framing matches how operators actually use these pages." },
  { post: "reading-migration-history-like-a-story", author: "sam@example.test", approved: true, body: "Migration names are underrated documentation." },
  { post: "small-audit-trails-for-internal-tools", author: "nina@example.test", approved: false, body: "Could this pattern work without a full event log?" },
  { post: "a-practical-sqlite-development-setup", author: "omar@example.test", approved: true, body: "SQLite is still the fastest way to get a believable local demo running." },
  { post: "making-empty-states-useful", author: "iris@example.test", approved: true, body: "This applies to admin tools more than people expect." },
  { post: "the-case-for-boring-test-data", author: "leo@example.test", approved: true, body: "Boring data is easier to debug than clever randomized data." },
  { post: "index-pages-that-respect-operators", author: "maya@example.test", approved: true, body: "Action placement matters a lot when the page is used under pressure." },
  { post: "preparing-demo-data-for-review", author: "nina@example.test", approved: true, body: "The relationship examples make the UI easier to evaluate." },
  { post: "documenting-foreign-keys-in-dummy-apps", author: "jon@example.test", approved: false, body: "I would add one polymorphic example later if the engine supports it." },
  { post: "keeping-admin-screens-fast-enough", author: "petra@example.test", approved: true, body: "Indexes plus pagination cover a surprising number of first releases." },
  { post: "keeping-admin-screens-fast-enough", author: "omar@example.test", approved: true, body: "Good reminder to measure before adding caching." }
]

if ActiveRecord::Base.connection.table_exists?(:blog_comments)
  comments.each do |attributes|
    comment = BlogComment.find_or_initialize_by(
      blog_post: posts_by_slug.fetch(attributes[:post]),
      body: attributes[:body]
    )
    comment.update!(
      blog_author: authors_by_email.fetch(attributes[:author]),
      approved: attributes[:approved]
    )
  end
end

taggings = {
  "shipping-a-rails-engine-with-confidence" => [ "engines", "active-record" ],
  "when-seeds-are-better-than-fixtures" => [ "seeds", "fixtures" ],
  "designing-tables-people-can-browse" => [ "admin-ui", "accessibility" ],
  "reading-migration-history-like-a-story" => [ "migrations" ],
  "small-audit-trails-for-internal-tools" => [ "admin-ui" ],
  "a-practical-sqlite-development-setup" => [ "sqlite" ],
  "making-empty-states-useful" => [ "admin-ui" ],
  "the-case-for-boring-test-data" => [ "fixtures" ],
  "index-pages-that-respect-operators" => [ "performance" ],
  "preparing-demo-data-for-review" => [ "seeds" ],
  "documenting-foreign-keys-in-dummy-apps" => [ "migrations" ],
  "keeping-admin-screens-fast-enough" => [ "performance" ]
}

taggings.each do |post_slug, tag_slugs|
  tag_slugs.each do |tag_slug|
    BlogTagging.find_or_create_by!(
      blog_post: posts_by_slug.fetch(post_slug),
      blog_tag: tags_by_slug.fetch(tag_slug)
    )
  end
end

comment_count =
  if ActiveRecord::Base.connection.table_exists?(:blog_comments)
    BlogComment.count
  else
    "pending migration"
  end

puts "Seeded blog example: #{BlogAuthor.count} authors, #{BlogAuthorProfile.count} profiles, #{BlogCategory.count} categories, #{BlogPost.count} posts, #{comment_count} comments, #{BlogTag.count} tags, #{BlogTagging.count} taggings."
