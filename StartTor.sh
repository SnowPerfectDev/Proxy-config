#!/bin/bash

# Cores ANSI 
 vermelho="\033[1;31m" 
 verde="\033[1;32m" 
 reset="\033[0m"

# Função para ocultar o cursor na tela
HIDECURSOR() {
    echo -en "\033[?25l"
}
HIDECURSOR
# Função para restaurar as configurações normais do terminal, incluindo a visibilidade do cursor
NORM() {
    echo -en "\033[?12l\033[?25h"
}

# Função para exibir mensagens de sucesso em verde 
 exibir_sucesso() {
     echo
     mensagem="$1" 
     echo -e "${reset}[${verde}+${reset}] ${mensagem}"${reset}
 sleep 2 
 }

# Função para exibir mensagens de alertas em vermelho 
 exibir_alerta() { 
     mensagem="$1" 
     echo -e "[${vermelho}!${reset}] ${mensagem}"${reset}
 }

# Função para interromper a conexão Tor e sair
function stop_tor() {
    exibir_alerta "Interrompendo a conexão Tor..."
    NORM
    pkill tor
    exit 0
}

# Configura o tratamento de Ctrl + C para chamar a função stop_tor
trap stop_tor SIGINT

# Inicia o Tor em segundo plano e redireciona a saída para um arquivo de log
tor > tor.log 2>&1 &

# Exibe uma mensagem de início
exibir_sucesso "Iniciando conexão Tor..."

# Define um tempo limite de inicialização (em segundos)
timeout=60
elapsed=0

while [ $elapsed -lt $timeout ]; do
    # Verifica se o Tor já está conectado no log
    if grep -q "Bootstrapped 100%" tor.log; then
        exibir_sucesso "Conexão Tor estabelecida (100%)"
        break
    else
        # Calcula a porcentagem aproximada de progresso
        progress=$(grep -oE "Bootstrapped [0-9]{1,3}%" tor.log | tail -n1 | grep -oE "[0-9]{1,3}")
        if [ -n "$progress" ]; then
            exibir_alerta "Progresso: $progress%"
        fi
    fi
    
    sleep 1
    elapsed=$((elapsed+1))
done

# Exemplo de lógica adicional: mantenha o script em execução
exibir_alerta "O script continuará em execução..."

# Mantém o script em execução indefinidamente (ou até ser interrompido manualmente)
while true; do
    sleep 1
done
NORM