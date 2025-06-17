    window.onload = function () {
    const savedEmail = localStorage.getItem("savedEmail");
    if (savedEmail) {
    document.getElementById("email").value = savedEmail;
}
};

    document.querySelector("form").addEventListener("submit", function () {
    const email = document.getElementById("email").value;
    localStorage.setItem("savedEmail", email);
});
