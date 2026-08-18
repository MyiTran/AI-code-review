import { setupStimulus } from '@/utils/setupStimulus';
import './ai_review_toggle';
import './review_tabs';
import '../admin'
setupStimulus(import.meta.glob('./**/*_controller.js', { eager: true }));
