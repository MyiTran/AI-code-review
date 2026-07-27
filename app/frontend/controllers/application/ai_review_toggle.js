const initializeAiReviewToggles = () => {
  document.querySelectorAll('.ai-review-toggle').forEach((toggle) => {
    if (toggle.dataset.initialized === 'true') return;

    toggle.dataset.initialized = 'true';

    toggle.addEventListener('change', () => {
      updateToggleStatus(toggle);
    });
  });
};

const updateToggleStatus = (toggle) => {
  const statusElement = document.getElementById(toggle.dataset.statusTarget);

  if (!statusElement) return;

  statusElement.textContent = toggleStatusText(toggle);
  statusElement.classList.toggle('text-success', toggle.checked);
  statusElement.classList.toggle('text-secondary', !toggle.checked);
};

const toggleStatusText = (toggle) => {
  const repositoryDetail = toggle.dataset.statusTarget === 'repository-auto-review-status';

  if (repositoryDetail) {
    return toggle.checked ? 'Automatic review is on' : 'Automatic review is off';
  }

  return toggle.checked ? 'On' : 'Off';
};

document.addEventListener('turbo:load', initializeAiReviewToggles);
