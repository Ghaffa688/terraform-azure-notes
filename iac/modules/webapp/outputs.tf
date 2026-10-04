output "webapp_name" {
  value = azurerm_linux_web_app.webapp[*].name
}

output "webapp_url" {
  value = [
    for app in azurerm_linux_web_app.webapp :
    "https://${app.default_hostname}"
  ]
}

output "webapp_id" {
  value = azurerm_linux_web_app.webapp[*].id
}