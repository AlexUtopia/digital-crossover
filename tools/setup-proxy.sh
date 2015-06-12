#!/bin/sh
#${1} - Proxy user name
#${2} - Proxy user password
#${3} - Proxy address
#${4} - Proxy port


# Input parameters check
helper()
{
    echo "use: ${0} <proxy_username> <proxy_userpasswd> <proxy_address> <proxy_port>"
}

if [ -z ${1} ]
then
    echo "proxy user name is empty"
    helper
    exit
fi

if [ -z ${2} ]
then
    echo "proxy user password is empty"
    helper
    exit
fi

if [ -z ${3} ]
then
    echo "proxy address is empty"
    helper
    exit
fi

if [ -z ${4} ]
then
    echo "proxy port is empty"
    helper
    exit
fi


# Configuration variables
PROXY_USER_NAME=${1}
PROXY_USER_PASSWD=${2}
PROXY_ADDR=${3}
PROXY_PORT=${4}


# Local variables
LOCAL_SOCAT_GIT_PROXY_CONFIG_FILE=~/.git-proxy



##################################
# Setup git/socat and wget utils #
##################################

sudo apt-get install git socat wget



##########################################
# Setup proxy for git (for git protocol) #
##########################################

# Create and fill socat configuration file
mkdir -p "$(dirname "${LOCAL_SOCAT_GIT_PROXY_CONFIG_FILE}")"
touch ${LOCAL_SOCAT_GIT_PROXY_CONFIG_FILE}
echo \
"\
#!/bin/sh
# Use socat to proxy git through an HTTP CONNECT firewall.
# Useful if you are trying to clone git:// from inside a company.
# Requires that the proxy allows CONNECT to port 9418.
#
# Save this file as gitproxy somewhere in your path (e.g., ~/bin) and then run
#   chmod +x ${LOCAL_SOCAT_GIT_PROXY_CONFIG_FILE}
#   git config --global core.gitproxy ${LOCAL_SOCAT_GIT_PROXY_CONFIG_FILE}
#
# More details at http://tinyurl.com/8xvpny

# Configuration. Common proxy ports are 3128, 8123, 8000.

exec socat STDIO PROXY:${PROXY_ADDR}:\$1:\$2,proxyport=${PROXY_PORT},proxyauth=${PROXY_USER_NAME}:${PROXY_USER_PASSWD}
" > ${LOCAL_SOCAT_GIT_PROXY_CONFIG_FILE}

# Change socat configuration file mode (execute)
chmod +x ${LOCAL_SOCAT_GIT_PROXY_CONFIG_FILE}

# Git configure
git config --global core.gitproxy ${LOCAL_SOCAT_GIT_PROXY_CONFIG_FILE}



###########################################
# Setup proxy for git (for http protocol) #
###########################################

# Git configure
git config --global http.proxy http://${PROXY_USER_NAME}:${PROXY_USER_PASSWD}@${PROXY_ADDR}:${PROXY_PORT}



#############################################
# Setup proxy for wget (http / https / ftp) #
#############################################

echo \
"\
use_proxy      = on
proxy-user     = ${PROXY_USER_NAME}
proxy-password = ${PROXY_USER_PASSWD}
http_proxy     = http://${PROXY_ADDR}:${PROXY_PORT}/
https_proxy    = http://${PROXY_ADDR}:${PROXY_PORT}/
ftp_proxy      = http://${PROXY_ADDR}:${PROXY_PORT}/
" > ~/.wgetrc

