require 'zendesk_api'

# Usage:
#   export ZENDESK_URL=foo.zendesk.com/api/v2
#   export ZENDESK_USER_EMAIL=email@email.com
#   export ZENDESK_USER_PASSWORD=p@ssw0rd
#   bundle exec ruby agents-with-default-groups.rb > agents-with-default-groups.csv

@client = ZendeskAPI::Client.new do |config|
  config.url = ENV['ZENDESK_URL']
  config.username = ENV['ZENDESK_USER_EMAIL']
  config.password = ENV['ZENDESK_USER_PASSWORD']

  config.retry = true
end


puts "Id,Name,DefaultGroupName"

(1..5).each do |page|
  @client.search(:query => "type:user role:agent").page(page).each do |agent|

    @client.groups.each do |group|
      @group_name = group['name'] if group['id'] == agent['default_group_id']
    end

    puts "#{agent['id']},#{agent['name']},#{@group_name if @group_name},"
  end
end
