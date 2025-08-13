Config = {}

Config.Locale = {
    interact_prompt = "[E] - Open Police Application",

    form_title = "Aplicação para LSPD",
    submit_button = "Enviar Aplicação",
    cancel_button = "Cancelar",

    success_notification = "Aplicação enviada com sucesso!",
    failure_notification = "Houve um erro ao enviar a aplicação. Tente novamente.",
    failure_not_in_zone = "Envio de aplicação falhou. Você não está na zona correta.",
    
    -- Discord Embed
    discord_embed_title = "Nova Aplicação de Polícia",
    discord_embed_footer = "Enviado por: %s %s | Citizen ID: %s", -- %s will be replaced with firstname, lastname, citizenid
}

Config.Locations = {
    {x = 441.4, y = -983.1, z = 30.7},
}

Config.Questions = {
    {label = "Nome completo", type = "text", required = true},
    {label = "Data de nascimento", type = "date", required = true},
    {label = "Número de Telefone", type = "tel", required = true},
    {label = "ID Discord (Padrão: 689975340138889246)", type = "text", required = true},
    {label = "Email @colorado.com (do aplicativo correio)", type = "text", required = true},
    {label = "Você já teve experiência na polícia americana? Se sim qual patente?", type = "textarea", required = true},
    {label = "De 0 a 10 qual seu nível de conhecimento com código 10?", type = "text", required = true},
    {label = "Por que você quer ingressar na LSPD?", type = "textarea", required = true},
    {label = "Fale um pouco sobre você e suas características principais:", type = "textarea", required = true},
    {label = "Por que você quer ingressar na LSPD?", type = "textarea", required = true},
}