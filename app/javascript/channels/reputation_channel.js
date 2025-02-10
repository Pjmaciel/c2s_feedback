import consumer from "./consumer";

consumer.subscriptions.create(
    { channel: "ReputationChannel", user_id: window.currentUserId },
    {
      received(data) {
        console.log("Dados recebidos via WebSocket:", data);

        if (data.status === "Erro ao buscar dados.") {
          document.querySelector("#status").textContent = "Erro ao buscar dados.";
          return;
        }

        document.querySelector("#company-name").textContent = data.company_name;
        document.querySelector("#solution-index").textContent = data.solution_rate;
        document.querySelector("#reputation-score").textContent = data.reputation_score;
        document.querySelector("#status").textContent = "Atualizado";
      },
    }
);
