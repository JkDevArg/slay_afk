#include <amxmodx>
#include <amxmisc>
#include <hamsandwich>
#include <fakemeta>

#define PLUGIN "AFK Slay"
#define VERSION "1.0"
#define AUTHOR "JkDev"
#define TAG "[ArenaGames]"

new Float:player_origin[33][3]
new g_time
new g_slayadmin

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR)

    g_time = register_cvar("amx_time_afk","30.0") //Setea los segundos
    g_slayadmin = register_cvar("amx_slay_admin","0") //Verifica si es admin [0 Para desactivar - 1 para activar]

    RegisterHam(Ham_Spawn, "player", "e_Spawn", 1);
}

public e_Spawn(id)
{
    remove_task(id)
    if(is_user_alive(id))
    {
        set_task(0.8, "obtiene_spawn", id);
    }
    return HAM_IGNORED;
}

public obtiene_spawn(id)
{
    pev(id, pev_origin, player_origin[id]);
    set_task(get_pcvar_float(g_time), "chequea_afk", id);
}

public chequea_afk(id)
{
    if(is_user_alive(id) && is_user_admin(id) == get_pcvar_num(g_slayadmin))
    {
        if(mismo_origen(id))
        {
            user_kill(id);
            new name[33];
            get_user_name(id, name, 32);
            client_print(0, print_chat,  "%s Jugador %s Fue slayeado por el servidor por estar AFK.", TAG, name);
        }
    }
}

public mismo_origen(id)
{
    new Float:origin[3];
    pev(id, pev_origin, origin);
    for(new i = 0; i < 3; i++)
        if(origin[i] != player_origin[id][i])
            return 0;
    return 1;
}
