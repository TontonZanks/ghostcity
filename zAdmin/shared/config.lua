Config = {
    openKey = 344, -- Correspond au F11
    noclipKey = 57, -- Corresponds au F10
    tpKey = 96,

    --[[
        -1  ->  Tous les groupes (sauf user)
    --]]
    authorizations = {
        ["vehicles"] = -1,
        ["kick"] = -1,
        ["mess"] = -1,
        ["jail"] = -1,
        ["unjail"] = -1,
        ["teleport"] = -1,
        ["revive"] = -1,
        ["heal"] = -1,
        ["tppc"] = -1,
        ["warn"] = -1,
        ["clearInventory"] = {"_dev", "superadmin"},
        ["clearLoadout"] = {"_dev", "superadmin"},
        ["ban"] = {"_dev", "superadmin"},
        ["setGroup"] = {"_dev", "superadmin"},
        ["give"] = {"_dev", "superadmin"},
        ["giveMoney"] = {"_dev", "superadmin"},
        ["wipe"] = {"_dev", "superadmin"},
        ["giveBoutique"] = {"_dev", "superadmin"},
    },

    webhook = {
        onTeleport = "https://discord.com/api/webhooks/853962625499004958/up3d5FdT0myeP79yDnUUsJRbc7dyTUX5RHp7pT6teUGII7erhngh-u_g2rYBYdl8MZew",
        onBan = "https://discord.com/api/webhooks/853962625499004958/up3d5FdT0myeP79yDnUUsJRbc7dyTUX5RHp7pT6teUGII7erhngh-u_g2rYBYdl8MZew",
        onKick = "https://discord.com/api/webhooks/853962625499004958/up3d5FdT0myeP79yDnUUsJRbc7dyTUX5RHp7pT6teUGII7erhngh-u_g2rYBYdl8MZew",
        onMessage = "https://discord.com/api/webhooks/853962625499004958/up3d5FdT0myeP79yDnUUsJRbc7dyTUX5RHp7pT6teUGII7erhngh-u_g2rYBYdl8MZew",
        onMoneyGive = "https://discord.com/api/webhooks/853962625499004958/up3d5FdT0myeP79yDnUUsJRbc7dyTUX5RHp7pT6teUGII7erhngh-u_g2rYBYdl8MZew",
        onItemGive = "https://discord.com/api/webhooks/853962625499004958/up3d5FdT0myeP79yDnUUsJRbc7dyTUX5RHp7pT6teUGII7erhngh-u_g2rYBYdl8MZew",
        onClear = "https://discord.com/api/webhooks/853962625499004958/up3d5FdT0myeP79yDnUUsJRbc7dyTUX5RHp7pT6teUGII7erhngh-u_g2rYBYdl8MZew",
        onGroupChange = "https://discord.com/api/webhooks/853962625499004958/up3d5FdT0myeP79yDnUUsJRbc7dyTUX5RHp7pT6teUGII7erhngh-u_g2rYBYdl8MZew",
        onRevive = "https://discord.com/api/webhooks/853962625499004958/up3d5FdT0myeP79yDnUUsJRbc7dyTUX5RHp7pT6teUGII7erhngh-u_g2rYBYdl8MZew",
        onHeal = "https://discord.com/api/webhooks/853962625499004958/up3d5FdT0myeP79yDnUUsJRbc7dyTUX5RHp7pT6teUGII7erhngh-u_g2rYBYdl8MZew",
        onWipe = "https://discord.com/api/webhooks/853962625499004958/up3d5FdT0myeP79yDnUUsJRbc7dyTUX5RHp7pT6teUGII7erhngh-u_g2rYBYdl8MZew"
    }
}