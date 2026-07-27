const reviewTabSelector = '[data-review-tab]';
const reviewPanelSelector = '[data-review-panel]';

const activateReviewTab = (button) => {
  const container = button.closest('.review-detail-tabs');

  if (!container) return;

  const selectedTab = button.dataset.reviewTab;

  updateTabButtons(container, button);
  updateTabPanels(container, selectedTab);
};

const updateTabButtons = (container, selectedButton) => {
  container.querySelectorAll(reviewTabSelector).forEach((button) => {
    const active = button === selectedButton;

    button.classList.toggle('active', active);
    button.setAttribute('aria-selected', active.toString());
  });
};

const updateTabPanels = (container, selectedTab) => {
  container.querySelectorAll(reviewPanelSelector).forEach((panel) => {
    const active = panel.dataset.reviewPanel === selectedTab;

    panel.classList.toggle('d-none', !active);
  });
};

document.addEventListener('click', (event) => {
  const button = event.target.closest(reviewTabSelector);

  if (!button) return;

  activateReviewTab(button);
});
