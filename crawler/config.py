#!encoding=utf-8

REGISTER_URL= 'http://172.29.33.188:9001/cluster/register'
HEARTBEAT_URL= 'http://172.29.33.188:9001/cluster/heartbeat'

RPC_ADDRESS = 'http://localhost:9001/RPC2'

AGENT_DIRECTORY='/opt/crawl/agent/'
SUPERVISOR_NAME_TEMPLATE = 'agent-{token}'

SUPERVISOR_AGENT_CONF_FILE = '/etc/supervisord.d/agent.conf'
HEARTBEAT_INTERVAL = 5

# Please do not change below

SUPERVISOR_TEMPLATE = """
[program:{name}]
command={base_dir}/run.sh {token}
numprocs=1
user=dc-agent
directory={base_dir}
stopsignal=TERM
autostart=false
autorestart=true
redirect_stderr=true
"""

SUPERVISOR_TEMPLATE=SUPERVISOR_TEMPLATE.format(base_dir=AGENT_DIRECTORY, token='{token}', name=SUPERVISOR_NAME_TEMPLATE)
