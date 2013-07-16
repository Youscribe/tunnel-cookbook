unless Chef::Config[:solo]
  case node['tunnel']['search_by']
  when "recipe"
    query = 'recipes:tunnel\:\:network'
  when "role"
    if node['tunnel']['role']
      query = "role:#{node['tunnel']['role']}"
    else
      return "no role provided"
    end
  else
    return "bad value for node['tunnel']['search_by']"
  end
  query += " AND chef_environment:#{node.chef_environment}" if node['tunnel']['restrict_environment']
  Chef::Log.debug("apt::cacher-client searching for '#{query}'")
  servers += search(:node, query)
end

servers.each do | server |
  unless server['tunnel']['network']['ipaddress']
    Chef::Log.info("Server #{server["hostname"]} can't be added in IPIP network")
    Chef::Log.info("Lack of information in node")
    next
  end

  tunnel_tunnel server["hostname"] do
    remote server['tunnel']['network']['ipaddress']
    local node['tunnel']['network']['ipaddress']
    ttl node['tunnel']['ttl'] if node['tunnel']['network']['ttl']
    interface node['tunnel']['interface'] if node['tunnel']['network']['interface']
  end
end
