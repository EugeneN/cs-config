

# cfg = window.APPCFG
cfg = require 'config/init'

{pubsubhub} = require 'libprotein'
{pub, sub} = pubsubhub()

get_data = (store, [k, tail...]) ->
    return undefined unless store

    if tail.length
        get_data store[k], tail
    else
        store[k]


set_data = (store, [k, tail...], data) ->
    return undefined unless k
    
    if tail.length
        store[k] or= {}
        store[k] = set_data store[k], tail, data
        store
    else
        store[k] = data
        store

get_config = (key) -> get_data cfg, (key.split '.')
set_config = (key, value) -> 
    set_data cfg, (key.split '.'), value
    pub key, (get_config key)

get = get_config
set = set_config

on_config_changed = (key, handler) ->
    sub key, handler

module.exports = {get_config, set_config, on_config_changed, get, set}
