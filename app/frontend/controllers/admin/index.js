import { setupStimulus } from '@/utils/setupStimulus';
import { togglePassword } from './password_toggle';

window.togglePassword = togglePassword;
setupStimulus(import.meta.glob('./**/*_controller.js', { eager: true }));
