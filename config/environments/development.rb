Illyan::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.active_support.deprecation        = :log
  
  # Do not compress assets
  config.assets.compress = false
 
  # Expands the lines which load the assets
  config.assets.debug = true

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false
  
  config.action_mailer.default_url_options = { :host => 'localhost:4001' }
  config.action_mailer.delivery_method = :file
end

Illyan::Application.site_title = "Sugar Pond Account Central"
Illyan::Application.site_logo = "account-central.png"
Illyan::Application.theme = "account-central"
Illyan::Application.account_name = "Sugar Pond account"
Illyan::Application.extra_login_page_html = <<-EOF
<script type="text/javascript">
$(function() {
  $("#account-explanation").hide();
  $("#show-account-explanation").click(function(e) { e.preventDefault(); $("#show-account-explanation").hide(); $("#account-explanation").show() });
});
</script>
<div style="background-color: rgba(255,255,255,0.3); border: 2px white solid; border-radius: 5px; padding: 5px; margin-bottom: 1em;">
  <a href="#" id="show-account-explanation">What's a Sugar Pond account?</a>
  <div id="account-explanation">
    <p>Sugar Pond accounts are shared between several web apps and convention web sites, including:</p>
    <ul style="padding-left: 0; margin-left: 0;">
      <li style="display: inline-block; margin-right: 2em;">&bull; Journey</li>
      <li style="display: inline-block; margin-right: 2em;">&bull; Vellum</li>
      <li style="display: inline-block; margin-right: 2em;">&bull; Festival of the LARPs</li>
      <li style="display: inline-block; margin-right: 2em;">&bull; SLAW</li>
      <li style="display: inline-block; margin-right: 2em;">&bull; Dice Bubble and Time Bubble</li>
    </ul>
    <p>If you've signed up for any of them, you can use the same password here.</p>
  </div>
</div>
EOF