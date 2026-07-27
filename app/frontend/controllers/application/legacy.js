const initializeAiReviewToggles = () => {
  document.querySelectorAll(".ai-review-toggle").forEach((toggle) => {
    if (toggle.dataset.initialized === "true") return;

    toggle.dataset.initialized = "true";

    toggle.addEventListener("change", () => {
      const targetId = toggle.dataset.statusTarget;
      const statusElement = document.getElementById(targetId);

      if (!statusElement) return;

      const isRepositoryDetail =
        targetId === "repository-auto-review-status";

      statusElement.textContent = toggle.checked
        ? (isRepositoryDetail ? "Automatic review is on" : "On")
        : (isRepositoryDetail ? "Automatic review is off" : "Off");

      statusElement.classList.toggle("text-success", toggle.checked);
      statusElement.classList.toggle("text-secondary", !toggle.checked);
    });
  });
};

document.addEventListener("turbo:load", initializeAiReviewToggles);

document.addEventListener("click", (event) => {
  const button = event.target.closest("[data-review-tab]");

  if (!button) return;

  const container = button.closest(".review-detail-tabs");

  if (!container) return;

  const selectedTab = button.dataset.reviewTab;

  container.querySelectorAll("[data-review-tab]").forEach((item) => {
    const active = item === button;

    item.classList.toggle("active", active);
    item.setAttribute("aria-selected", active.toString());
  });

  container.querySelectorAll("[data-review-panel]").forEach((panel) => {
    const active = panel.dataset.reviewPanel === selectedTab;

    panel.classList.toggle("d-none", !active);
  });
});