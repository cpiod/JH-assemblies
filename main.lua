classes = { "klass_marine", "klass_scout", "klass_technician" }

table.insert(blueprints["klass_marine"].klass.traits, #blueprints["klass_marine"].klass.traits-4, { "trait_assembly", max = 3, require = { ktrait_army_surplus = 1, } })
table.insert(blueprints["klass_scout"].klass.traits, #blueprints["klass_scout"].klass.traits-4, { "trait_assembly", max = 3, require = { trait_hacking = 1, } })
table.insert(blueprints["klass_technician"].klass.traits, #blueprints["klass_technician"].klass.traits-4, { "trait_assembly", max = 3, require = { trait_whizkid = 1, } })

function complete_assembly(assembly, desc, mt_cost, relic_cost, heart_cost, max_hp_cost)
    local len = #assembly
    for j = 1,len do
        v = assembly[j]
        v.mt = mt_cost
        v.relic = relic_cost
        v.heart = heart_cost
        v.max_hp = max_hp_cost
        v.desc = desc
        local l = {}
        for k,i in pairs(v) do
            l[k] = i
        end
        l.base = "adv_"..l.base
        table.insert(assembly, l)
    end
end

-- cost 1 multitool
assembly_l1 = {
    { base = "knife", new = "exo_knife", A = 1, P = 1 },
    { base = "apistol", new = "exo_blaster", A = 1, P = 1 },
    { base = "hunter_rifle", new = "exo_toxi_rifle", P = 1, B = 1 },
    { base = "auto_rifle", new = "exo_nailgun", B = 1, P = 1 },

    -- yellow to red
    { base = "pistol", new = "apistol", B = 1, A = 1 }, -- pistol to 7.62 sidearm
    { base = "pistol", new = "bpistol", B = 1, A = 1 }, -- pistol to combat pistol
    { base = "rpistol", new = "lpistol", B = 1, A = 1 }, -- revolver to long revolver
    { base = "smg", new = "asmg", B = 1, A = 1 }, -- SMG to 7.62 SMG
    { base = "smg", new = "esmg", B = 1, A = 1 }, -- SMG to plasma SMG
    { base = "hunter_rifle", new = "long_rifle", B = 1, A = 1 },
    { base = "hunter_rifle", new = "rail_rifle", B = 1, A = 1 },
    { base = "chaingun", new = "hyperblaster", B = 1, A = 1 },
    { base = "shotgun", new = "dshotgun", B = 1, A = 1 }, -- 12ga shotgun to dual shotgun
    { base = "ashotgun", new = "dshotgun", B = 1, A = 1 }, -- auto-shotgun to dual shotgun
    { base = "rocket_launcher", new = "energy_cannon", B = 1, A = 1 },

    -- grenades
    { base = "grenade_launcher", new = "frag_grenade" },
    { base = "grenade_launcher", new = "emp_grenade" },
    { base = "grenade_launcher", new = "smoke_grenade" },

    -- helmet
    { base = "helmet_green", new = "exo_helmet_scout", P = 1, B = 1, A = 1 },
    { base = "helmet_blue", new = "exo_helmet_scout", P = 1, B = 1, A = 1 },
    { base = "helmet_red", new = "exo_helmet_scout", P = 1, B = 1, A = 1 },
    { base = "helmet_green", new = "exo_helmet_marine", P = 1, B = 1, A = 1 },
    { base = "helmet_blue", new = "exo_helmet_marine", P = 1, B = 1, A = 1 },
    { base = "helmet_red", new = "exo_helmet_marine", P = 1, B = 1, A = 1 },
    { base = "helmet_green", new = "exo_helmet_tech", P = 1, B = 1, A = 1 },
    { base = "helmet_blue", new = "exo_helmet_tech", P = 1, B = 1, A = 1 },
    { base = "helmet_red", new = "exo_helmet_tech", P = 1, B = 1, A = 1 },

    -- armor
    { base = "armor_green", new = "exo_armor_duramesh", P = 1, B = 1, A = 1 },
    { base = "armor_blue", new = "exo_armor_duramesh", P = 1, B = 1, A = 1 },
    { base = "armor_red", new = "exo_armor_duramesh", P = 1, B = 1, A = 1 },
}

complete_assembly(assembly_l1, "Cost: 1 multitool", 1)

-- cost 2 multitools and a relic
assembly_l2 = {
    { base = "exo_egls", new = "exo_egls" }, -- "reload" EGLS
    { base = "exo_mag_rifle", new = "exo_mag_rifle" }, -- "reload" railgun
    { base = "exo_armor_ablative", new = "exo_armor_ablative" }, -- "repair" ablative
    { base = "exo_nailgun", new = "exo_snailgun" },
    { base = "rocket_launcher", new = "exo_toxin_launcher", P = 1, B = 1, A = 1 },
    { base = "medkit_large", new = "combatpack_large" },
}

complete_assembly(assembly_l2, "Cost: 2 multitools and 1 relic", 2, 1)

-- cost the heart and 10 max HP
assembly_l3 = {
    -- tier 1 -> tier 2, tier 2 -> tier 3 weapon of the same type, requires heart so cannot be cumulated with dark cathedral
    { base = "uni_helmet_fiendcrown", new = "uni_helmet_overlord" },
    { base = "uni_helmet_overlord", new = "uni_helmet_firecrown" },
    { base = "uni_armor_shadowcloak", new = "uni_armor_cybersuit" },
    { base = "uni_armor_cybersuit", new = "uni_armor_exosuit" },
    { base = "uni_revolver_love", new = "uni_pistol_hate" },
    { base = "uni_pistol_hate", new = "uni_pistol_death" },
    { base = "uni_rifle_thompson", new = "uni_rifle_hammerhead" },
    { base = "uni_rifle_hammerhead", new = "uni_rifle_avalanche" },
    { base = "uni_semi_vengeance", new = "uni_semi_bloodletter" },
    { base = "uni_semi_bloodletter", new = "uni_semi_shadowhunter" },
    { base = "uni_smg_carnage", new = "uni_smg_viper" },
    { base = "uni_smg_viper", new = "uni_smg_void" },
    { base = "uni_shotgun_monster", new = "uni_shotgun_denial" },
    { base = "uni_shotgun_denial", new = "uni_shotgun_wavedancer" },
    { base = "uni_knife", new = "uni_katana" },
    { base = "uni_katana", new = "uni_sword" },
    { base = "uni_launcher_firestorm", new = "uni_launcher_calamity" },
    { base = "uni_launcher_calamity", new = "uni_bfg" },
    { base = "uni_scrapgun", new = "uni_vulcan" },
    { base = "uni_vulcan", new = "uni_apocalypse" },

    -- upgrade exo to tier 1 unique
    { base = "exo_helmet_blast", new = "uni_helmet_fiendcrown" },
    { base = "exo_helmet_battle", new = "uni_helmet_fiendcrown" },
    { base = "exo_helmet_marine", new = "uni_helmet_fiendcrown" },
    { base = "exo_helmet_scout", new = "uni_helmet_fiendcrown" },
    { base = "exo_helmet_tech", new = "uni_helmet_fiendcrown" },
    { base = "exo_visor_command", new = "uni_helmet_fiendcrown" },
    { base = "exo_visor_supply", new = "uni_helmet_fiendcrown" },
    { base = "exo_visor_analytic", new = "uni_helmet_fiendcrown" },

    { base = "exo_armor_guardian", new = "uni_armor_shadowcloak" },
    { base = "exo_armor_ablative", new = "uni_armor_shadowcloak" },
    { base = "exo_armor_medifiber", new = "uni_armor_shadowcloak" },
    { base = "exo_armor_duramesh", new = "uni_armor_shadowcloak" },
    { base = "exo_armor_necrotic", new = "uni_armor_shadowcloak" },
    { base = "exo_armor_scout", new = "uni_armor_shadowcloak" },
    { base = "exo_armor_tech", new = "uni_armor_shadowcloak" },
    { base = "exo_armor_marine", new = "uni_armor_shadowcloak" },


    { base = "exo_saw", new = "uni_knife" },
    { base = "exo_knife", new = "uni_knife" },
    { base = "exo_sword", new = "uni_knife" },
    { base = "exo_ksword_marine", new = "uni_knife" },
    { base = "exo_ksword_scout", new = "uni_knife" },
    { base = "exo_ksword_tech", new = "uni_knife" },
    { base = "exo_katana", new = "uni_knife" },
    { base = "exo_ancient_sword", new = "uni_knife" },

    { base = "exo_cpistol", new = "uni_revolver_love" },
    { base = "exo_mpistol", new = "uni_revolver_love" },
    { base = "exo_dpistol", new = "uni_revolver_love" },
    { base = "exo_blaster", new = "uni_revolver_love" },
    { base = "exo_jpistol", new = "uni_revolver_love" },
    { base = "exo_fpistol", new = "uni_revolver_love" },

    { base = "exo_tsmg", new = "uni_smg_carnage" },
    { base = "exo_jsmg", new = "uni_smg_carnage" },
    { base = "exo_csmg", new = "uni_smg_carnage" },
    { base = "exo_ssmg", new = "uni_smg_carnage" },

    { base = "exo_toxi_rifle", new = "uni_semi_vengeance" },
    { base = "exo_awp_rifle", new = "uni_semi_vengeance" },
    { base = "exo_mag_rifle", new = "uni_semi_vengeance" },
    { base = "exo_emp_rifle", new = "uni_semi_vengeance" },
    { base = "exo_railgun", new = "uni_semi_vengeance" },

    { base = "exo_snailgun", new = "uni_scrapgun" },
    { base = "exo_gatling_gun", new = "uni_scrapgun" },

    { base = "exo_cshotgun", new = "uni_shotgun_monster" },
    { base = "exo_fshotgun", new = "uni_shotgun_monster" },
    { base = "exo_gshotgun", new = "uni_shotgun_monster" },
    { base = "exo_jshotgun", new = "uni_shotgun_monster" },
    { base = "exo_sshotgun", new = "uni_shotgun_monster" },

    { base = "exo_egls", new = "uni_launcher_firestorm" },
    { base = "exo_grenade_launcher", new = "uni_launcher_firestorm" },
    { base = "exo_micro_launcher", new = "uni_launcher_firestorm" },
    { base = "exo_toxin_launcher", new = "uni_launcher_firestorm" },
    { base = "exo_bfg", new = "uni_launcher_firestorm" },

    { base = "exo_tac_rifle", new = "uni_rifle_thompson" },
    { base = "exo_precision_rifle", new = "uni_rifle_thompson" },
    { base = "exo_ac_rifle", new = "uni_rifle_thompson" },
    { base = "exo_nailgun", new = "uni_rifle_thompson" },
    { base = "exo_ancient_gun", new = "uni_rifle_thompson" },

    { base = "adv_amp_general", new = "powerup_backpack" },
    { base = "exo_ancient_gun", new = "exo_pack_nano" },
    { base = "exo_ancient_gun", new = "exo_pack_onyx" },
    { base = "exo_ancient_sword", new = "exo_pack_nano" },
    { base = "exo_ancient_sword", new = "exo_pack_onyx" },
    { base = "ancient_relic_ancient_necklace", new = "exo_pack_nano" },
    { base = "ancient_relic_ancient_necklace", new = "exo_pack_onyx" },
    { base = "ancient_relic_ancient_armband", new = "exo_pack_nano" },
    { base = "ancient_relic_ancient_armband", new = "exo_pack_onyx" },

}

complete_assembly(assembly_l3, "Cost: -10 max HP and the frozen heart", nil, nil, 1, 10)

all_assemblies = { assembly_l1, assembly_l2, assembly_l3 }

function can_pay(player, base, new, recipes_list)
    for _,v in ipairs(recipes_list) do
        if base == v.base and new == v.new then -- found it
            if string.match(v.new,"scout") and world:get_id(player) ~= "player_scout" then
                return false
            end
            if string.match(v.new,"tech") and world:get_id(player) ~= "player_technician" then
                return false
            end
            if string.match(v.new,"marine") and world:get_id(player) ~= "player_marine" then
                return false
            end

            -- can pay?
            return not ((v.mt and world:has_item( player, "kit_multitool" ) < v.mt) or
            (v.heart and world:has_item( player, "frozen_heart") == 0) or
            (v.relic and not world:get_slot( player, "relic" )) or
            (v.max_hp and player.health.current <= v.max_hp))
        end
    end
end

function pay_cost(player, item, new, recipes_list)
    local level = world:get_level()
    for _,v in ipairs(recipes_list) do
        if world:get_id(item) == v.base and new == v.new then -- found it
            -- pay
            if v.mt then
                world:remove_items(player, "kit_multitool", v.mt)
            end
            if v.heart then
                world:remove_items(player, "frozen_heart", 1)
            end
            if v.relic then
                local r = world:get_slot(player, "relic")
                level:drop_item(player, r)
                world:destroy(r)
            end
            if v.max_hp then
                level:apply_damage( player, player, v.max_hp, ivec2(), "internal" )
                player.attributes.health = player.attributes.health - v.max_hp
            end
            return true
        end
    end
    return false
end


function get_recipes(player, item, recipes, recipes_list)
    local mods        = core.blueprint_list_by_data_entry( "mod" )
    local result      = {}
    local mod_data    = {}
    for _,m in ipairs( mods ) do
        mod_data[ m.id ] = m.data.mod
    end
    for c in ecs:children( item ) do
        local mid      = world:get_id( c )
        local mod_data = mod_data[ mid ]
        if mod_data then
            local letter     = mod_data.letter
            local level      = c.attributes.mod_level
            result[ letter ] = level
        end
    end

    local mods = {"P","A","B","S","V","C","E","O","N"}
    for _,v in ipairs(recipes_list) do
        if world:get_id(item) == v.base then
            local good = true
            -- check all requirements
            for _,mod in ipairs(mods) do
                if v[mod] and not (result[mod] and result[mod] >= v[mod]) then
                    good = false
                    break
                end
            end
            if good and can_pay(player, v.base, v.new, recipes_list) then
                table.insert(recipes, v)
            end
        end
    end

    return recipes
end

function get_all_possible_assemblies(self, entity)
    local list = {}
    local max_len = 1
    local slots = {"1","2","3","4","armor","head","utility"}
    for _,slot in ipairs(slots) do
        local item = world:get_slot( entity, slot )
        if item then
            local recipes = {}
            for i = 1, entity.attributes.assembly_level do
                get_recipes(entity, item, recipes, all_assemblies[i])
            end
            for _,recipe in ipairs(recipes) do
                -- put assembly level
                local name = world:get_name(item).." {Y=>} "..world:get_text(recipe.new,"name")
                max_len = math.max( max_len, string.len( name ) )
                table.insert(list, {
                    name = name,
                    target = self,
                    parameter = item,
                    id = recipe.new,
                    desc = recipe.desc
                })
            end
        end
    end
    return list, max_len
end

function run_assembly_ui( self, entity )
    local list, max_len = get_all_possible_assemblies(self, entity)

    if #list == 0 then
        ui:set_hint( "Nothing to assemble!", 1001, 0 )
        return
    end

    table.insert( list, {
        name = ui:text("ui.lua.common.cancel"),
        target = self,
        cancel = true,
    })
    list.title = "What to assemble?"
    list.size  = coord( math.max( 30, max_len + 6 ), 0 )
    list.fsize = 1
    ui:terminal( entity, what, list )
end

register_blueprint "trait_assembly"
{
    blueprint = "trait",
    text = {
        name   = "Assembler",-- indicate current number of availables assemblies
        desc   = "ACTIVE SKILL - You make new toys from old ones. Manufacturer perks are kept!",
        full   = [[{!LEVEL 1} - Cost: {!1 multitool}
 PA combat knife  => quickblade
 PA 7.62 sidearm  => CRI blaster
 PB hunter rifle  => toxin rifle
 PB 9mm auto rif. => nail gun
 BA yellow weapon => red weapon{!*}
 PBA armor        => duramesh armor
 PBA helmet       => class helmet
 grenade launcher => frag/EMP/smoke nade
{!LEVEL 2} - Cost: {!2 multitools}, {!1 relic}
 restore magrail / EGLS / ablative armor
 nail gun         => super nailgun
 PBA rocket laun. => bio launcher
 large medkit     => large combat pack
{!LEVEL 3} - Cost: {!-10 max HP}, {!frozen heart}
 exotic item      => tier 1 unique{!*}
 unique item      => next tier unique{!*}
 utility AMP      => CRI backpack
 Ancient’s drop   => O or N mod pack
  {!*} item type is preserved]],
        abbr   = "Asm",
    },
    callbacks = {

        on_use = [=[
            function( self, entity )
                if entity == world:get_player() then
                    run_assembly_ui( self, entity )
                    return -1
                else 
                    return -1
                end
            end
        ]=],

        on_post_command = [=[
            function ( self, actor, cmt, weapon, time )
                local list = get_all_possible_assemblies(self, actor)
                self.skill.charge = #list
            end
        ]=],

        on_activate = [=[
            function ( self, player, level, param, id )
                if level then -- UI
                    if param then
                        local recipe_level = nil
                        local item = param
                        local new = world:resolve_hash( id )
                        for i = 1, player.attributes.assembly_level do
                            local paid = pay_cost(player, item, new, all_assemblies[i])
                            if paid then
                                recipe_level = i
                                break
                            end
                        end

                        if world:get_id(item) == new then
                            -- restore
                            if item.clip then -- restore ammo
                                world:play_sound( "reload", player )
                                item.clip.count = item.attributes.clip_size
                            end
                            if item.health then -- restore durability
                                world:play_sound( "armor_shard", player )
                                item.health.current = item.attributes.health
                            end
                        else
                            -- transform
                            if recipe_level == 3 then
                                world:play_voice("vo_unique")
                            else
                                world:play_voice("vo_special_box")
                            end

                            local manu_to_apply = nil
                            local manufacturer_perks = {"man_vs", "man_vs_slot", "man_mdf", "man_mdf_slot", "man_js", "man_js_slot", "man_eri", "man_eri_slot", "man_at", "man_at_slot", "man_ccb", "man_ccb_slot", "man_crt", "man_crt_armor", "man_crt_head", "man_idr", "man_idr_slot", "man_ttl", "man_ttl_slot", "man_cri", "man_cri_slot"}
                            for _,v in ipairs(manufacturer_perks) do
                                if ecs:child(item, v) then
                                    manu_to_apply = v
                                    break
                                end
                            end

                            level:drop_item( player, item )
                            world:destroy(item)
                            local new_item = player:pickup( new, true )

                            -- apply manufacturer perk
                            -- blaster will override anyway
                            if manu_to_apply and not (new_item.data and new_item.data.unique) then
                                generator.apply_manufacturer(new_item, manu_to_apply)
                            end
                        end
                        return 100
                    end
                    return 0
                else -- trait is bought
                    player.attributes.assembly_level = ( player.attributes.assembly_level or 0 ) + 1
                    if player.attributes.assembly_level == 1 then
                        player:attach("trait_assembly")
                    end
                end
            end
        ]=],
    },
    skill = {
        cooldown = 0,
        cost = 0,
        charge = 0
    },
}
