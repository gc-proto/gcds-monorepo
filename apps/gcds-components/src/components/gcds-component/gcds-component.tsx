import {
  Component,
  Element,
  Event,
  EventEmitter,
  Host,
  Prop,
  State,
  Watch,
  h,
} from '@stencil/core';
import { assignLanguage, observerConfig, logError, emitEvent } from '../../utils/utils';
import i18n from './i18n/i18n';

/**
 * Component description goes here.
 *
 * @slot default - Description of default slot.
 * @slot other-slot - Description of named slot.
 */
@Component({
  tag: 'gcds-component',
  styleUrl: 'gcds-component.css',
  shadow: true,
})
export class GcdsComponent {
  @Element() el: HTMLElement;

  // Props (with validation)
  @Prop({ reflect: true }) requiredProp!: string;
  @Prop() optionalProp?: string = 'default';

  // States
  @State() lang: string;
  @State() errors: Array<string> = [];
  @State() inheritedAttributes: Object = {};

  // Events
  @Event() gcdsEventName!: EventEmitter<void>;

  // Watchers
  @Watch('requiredProp')
  validateRequiredProp() {
    if (!this.requiredProp || this.requiredProp.trim() == '') {
      this.errors.push('requiredProp');
    } else if (this.errors.includes('requiredProp')) {
      this.errors.splice(this.errors.indexOf('requiredProp'), 1);
    }
  }

  @Watch('aria-invalid')
  ariaInvalidWatcher() {
    this.inheritedAttributes = inheritAttributes(this.el, this.shadowElement);
  }

  // Private methods
  private updateLang() {
    const observer = new MutationObserver(mutations => {
      if (mutations[0].oldValue != this.el.lang) {
        this.lang = this.el.lang;
      }
    });
    observer.observe(this.el, observerConfig);
   }
  private validateRequiredProps() {
    this.validateRequiredProp();

    if (this.errors.includes('requiredProp')) {
      return false;
    }

    return true;
  }

  // Lifecycle methods
  async componentWillLoad() { /* ... */ }

  // Render method
  render() {
    const { lang } = this;

    return (
      <Host>
        <div class="gcds-example">
          <h2>{this.requiredProp}</h2>
          <p>{this.optionalProp}</p>
          <button aria-label={i18n[lang].buttonLabel}>
            {i18n[lang].buttonText}
          </button>
          <slot></slot>
        </div>
      </Host>
    );
  }
}
