export function togglePassword(id, button) {
  const input = document.getElementById(id);
  const icon = button.querySelector('i');

  input.type = input.type === 'password' ? 'text' : 'password';
  icon.classList.toggle('bi-eye');
  icon.classList.toggle('bi-eye-slash');
}
