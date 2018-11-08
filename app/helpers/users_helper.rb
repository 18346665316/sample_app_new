module UsersHelper
  def gravatar_for user, options={size:80}
    gravator_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravator_url = "https://secure.gravatar.com/avatar/#{gravator_id}?s=#{size}"
    image_tag(gravator_url, alt: user.name, class: "gravatar")
  end
end
