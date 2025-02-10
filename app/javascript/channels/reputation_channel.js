import consumer from "./consumer";

consumer.subscriptions.create(
    { channel: "ReputationChannel", user_id: window.currentUserId },
    {
        received(data) {
            console.log("📡 Dados recebidos via WebSocket:", data);

            if (data.error) {
                document.querySelector("#company-name").textContent = "Não encontrado";
                document.querySelector("#solution-index").textContent = "N/A";
                document.querySelector("#reputation-score").textContent = "N/A";
                return;
            }

            document.querySelector("#company-name").textContent = data.company_name;
            document.querySelector("#solution-index").textContent = data.reviews_count;
            document.querySelector("#reputation-score").textContent = data.rating;
            document.querySelector("#status").textContent = "Atualizado";
        }
    }
);
