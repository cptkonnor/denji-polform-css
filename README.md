# denji-polform

A highly configurable Police Job Application script for QBCore servers. It allows players to apply for the police force at set locations in-game, sending their applications to a Discord channel via a webhook.

---

## Features

-   **Customizable Questions:** Add, remove, or edit any question in the application directly from the config.
-   **Multiple Locations:** Set up as many application locations across the map as you need.
-   **Discord Integration:** Receive detailed application embeds directly in a Discord channel of your choice.
-   **Secure:** Uses server-side validation to prevent unauthorized event triggers and keeps your webhook URL out of shared files.

---

## Preview

![Police Application UI](https://i.imgur.com/xmK4JyQ.png)

---

## Dependencies

-   [qb-core](https://github.com/qbcore-framework/qb-core)

---

## Installation

1.  Download the resource and place it in your main `resources` directory.
2.  Configure your Discord webhook (see below).
3.  Customize the `config.lua` file to your liking.

---

## Configuration

### 1. Discord Webhook (Required)

For security, the Discord webhook URL **must** be set in your `server.cfg`, not the `config.lua`. This prevents your webhook from being exposed if you share the code.

Add this line to your `server.cfg`:

```lua
setr police_app_webhook "https://discord.com/api/webhooks/your/webhook_url_here"
```

### 2. Main Config (config.lua)

This table holds all text. Translate the text within the quotes to change the language of the script.

```lua
Config.Locale = {
    interact_prompt = "[E] - Open Police Application",

    form_title = "Police Job Application",
    submit_button = "Submit Application",
    cancel_button = "Cancel",

    success_notification = "Application submitted successfully!",
    failure_notification = "There was an error submitting your application.",
    failure_not_in_zone = "Submission failed: You are not at an application terminal.",
    
    discord_embed_title = "New Police Application",
    discord_embed_footer = "Submitted by: %s %s | Citizen ID: %s",
}
```

**Add or remove vector3 coordinates to define where players can open the application form.**

```lua
Config.Locations = {
    {x = 441.4, y = -983.1, z = 30.7},
    -- You can add another location like this:
    -- {x = 1846.13, y = 2586.21, z = 45.67},
}
```

Define the questions for your application. You can add, remove, or edit any entry in this table.

---

**label**: The question text.

**type**: The input type. Supported types are "text", "date", "tel", and "textarea".

**required**: Set to true if the question is mandatory, false otherwise.

---

```lua
Config.Questions = {
    {label = "What is your full name?", type = "text", required = true},
    {label = "What is your date of birth?", type = "date", required = true},
    {label = "What is your phone number?", type = "tel", required = true},
    {label = "Why do you want to become a police officer?", type = "textarea", required = true},
    {label = "Do you have any prior experience in law enforcement?", type = "textarea", required = false},
    {label = "Please describe your character's personality and background.", type = "textarea", required = true},
}
```