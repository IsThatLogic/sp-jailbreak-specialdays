public void SpecialDay_Dodgeball_Begin()
{
    SetConVarBool(g_FriendlyFire, true);
    RemoveAllWeapons();

    for (int i = 1; i <= MaxClients; i++)
    {
        if (!IsValidClient(i) || !IsPlayerAlive(i))
            continue;
        
        SetEntityHealth(i, 1);
        StripAllWeapons(i);
        GivePlayerItem(i, "weapon_flashbang");
        SetEntProp(i, Prop_Data, "m_ArmorValue", 0.0);
        SetEntityGravity(i, 0.6);
    }
}

public void SpecialDay_Dodgeball_End()
{

    SetConVarBool(g_FriendlyFire, false);

    for (int i = 1; i <= MaxClients; i++)
    {   
        if (IsValidClient(i))
        {
            PrintToChatAll("Setting %N's gravity", i);
            SetEntityGravity(i, 1.0);            
        }
    }

}

public Action Dodgeball_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{
    damage = 500.0;
    return Plugin_Changed;
}

public void Dodgeball_OnEntityCreated(int entity, const char[] classname)
{
    if (StrEqual(classname, "flashbang_projectile"))
        CreateTimer(1.4, Timer_GiveFlash, entity);
}

public Action Timer_GiveFlash(Handle timer, any entity)
{
    int client = GetEntPropEnt(entity, Prop_Data, "m_hOwnerEntity");

    if (IsValidEntity(entity))
        AcceptEntityInput(entity, "Kill");

    if (IsValidClient(client) && IsPlayerAlive(client))
    {
        StripAllWeapons(client);
        GivePlayerItem(client, "weapon_flashbang");
        SetEntityHealth(client, 1);  

    }
}