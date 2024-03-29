// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "trix"
import "@rails/actiontext"

import LocalTime from "local-time"
LocalTime.start()

document.addEventListener("DOMContentLoaded", function() {
  var timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
  document.cookie = "timezone=" + encodeURIComponent(timezone) + "; path=/";
});
