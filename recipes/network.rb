unless Chef::Config[:solo]
  case node['ipip']['search_by']
  when "recipe"
    query = 'recipes:ipip\:\:network'
  when "role"
    if node['ipip']['role']
      query = "role:#{node['ipip']['role']}"
    else
      return "no role provided"
    end
  else
    return "bad value for node['ipip']['search_by']"
  end
  query += " AND chef_environment:#{node.chef_environment}" if node['ipip']['restrict_environment']
  Chef::Log.debug("apt::cacher-client searching for '#{query}'")
  servers += search(:node, query)
end

servers.each do | server |
  unless server['ipip']['network']['ipaddress']
    Chef::Log.info("Server #{server["hostname"]} can't be added in IPIP network")
    Chef::Log.info("Lack of information in node")
    next
  end

  ipip_tunnel server["hostname"] do
    remote server['ipip']['network']['ipaddress']
    local node['ipip']['network']['ipaddress']
    ttl node['ipip']['ttl'] if node['ipip']['network']['ttl']
    interface node['ipip']['interface'] if node['ipip']['network']['interface']
  end
end
