document.addEventListener("turbo:load", function () {
    const registrationInput = document.getElementById("registration_number");
    const errorDiv = document.getElementById("registration_number_error");
    const submitButton = document.querySelector('input[type="submit"]');

    if (registrationInput && errorDiv && submitButton) {
        // Habilita ou desabilita o botão com base no valor do campo
        function validateRegistration() {
            const value = registrationInput.value.trim();

            if (/^[VG]\d{4}$/.test(value)) {
                errorDiv.style.display = "none"; // Esconde a mensagem de erro
                registrationInput.setCustomValidity(""); // Remove erro do campo
                submitButton.disabled = false; // Habilita o botão de envio
            } else {
                errorDiv.style.display = "block"; // Exibe a mensagem de erro
                registrationInput.setCustomValidity("O número de registro deve estar no formato V1234 ou G1234.");
                submitButton.disabled = true; // Desabilita o botão
            }
        }

        // Verifica a cada vez que o usuário digita no campo
        registrationInput.addEventListener("input", validateRegistration);

        // Executa a validação ao carregar a página (importante para casos de recarregamento)
        validateRegistration();
    }
});
