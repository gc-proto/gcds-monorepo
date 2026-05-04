import {
  Component,
  Element,
  Prop,
  State,
  Watch,
  Host,
  h
} from "@stencil/core";
import { assignLanguage, observerConfig, logError } from "../../utils/utils";
import i18n from "./i18n/i18n";

export interface ServiceItem {
  linkText: string;
  linkHref: string;
  description: string;
}

/**
 * The Service and Information component provides links to commonly used services and information.
 *
 * @slot default - Slot for doormat content
 */
@Component({
  tag: "gcds-srvinfo",
  styleUrl: "gcds-srvinfo.css",
  shadow: true,
})
export class GcdsSrvinfo {
  @Element() el!: HTMLElement;

  /**
   * Number of service items to display (1-9)
   */
  @Prop({ reflect: true }) items: number = 9;
  @Watch('items')
  validateItems() {
    if (this.items < 1 || this.items > 9) {
      this.items = Math.min(Math.max(1, this.items), 9);
    }
  }

  /**
   * Apply banding background to the section
   */
  @Prop({ reflect: true }) banded: boolean = false;

  /**
   * Whether to show the heading
   */
  @Prop({ reflect: true }) headingVisible: boolean = false;

  /**
   * Number of columns for desktop layout (1 or 3)
   */
  @Prop({ reflect: true }) columns: boolean = true;
  @Watch('columns')
  validateColumns() {
    // No validation needed for boolean type
  }

  /**
   * Array of service items with linkText, linkHref, and description.
   * Accepts an array of objects or a JSON string.
   */
  @Prop({ mutable: true }) serviceItems: Array<ServiceItem> | string = '[]';
  @Watch('serviceItems')
  parseServiceItems() {
    if (typeof this.serviceItems === 'string') {
      try {
        this.serviceItems = JSON.parse(this.serviceItems);
      } catch (e) {
        console.error('Error parsing serviceItems JSON:', e);
        this.serviceItems = [];
        this.errors.push('serviceItems');
        return;
      }
    }

    if (!Array.isArray(this.serviceItems)) {
      this.serviceItems = [];
      this.errors.push('serviceItems');
      return;
    }

    // Validate each item has required properties
    const validItems = (this.serviceItems as Array<ServiceItem>).filter(item =>
      item && item.linkText && item.linkHref && item.description
    );

    if (validItems.length !== (this.serviceItems as Array<ServiceItem>).length) {
      console.error('Some service items are missing required properties (linkText, linkHref, description)');
    }

    this.serviceItems = validItems;

    // Remove error if validation passes
    if (this.errors.includes('serviceItems') && Array.isArray(this.serviceItems)) {
      this.errors.splice(this.errors.indexOf('serviceItems'), 1);
    }
  }

  /**
   * Language of rendered component
   */
  @State() lang!: string;

  /**
   * State to track validation on properties
   */
  @State() errors: Array<string> = [];

  /*
   * Observe lang attribute change
   */
  private updateLang() {
    const observer = new MutationObserver(mutations => {
      if (mutations[0].oldValue != this.el.lang) {
        this.lang = this.el.lang;
      }
    });
    observer.observe(this.el, observerConfig);
  }

  /*
   * Validate required properties
   */
  private validateRequiredProps(): boolean {
    this.parseServiceItems();
    this.validateItems();
    this.validateColumns();

    if (this.errors.length > 0) {
      return false;
    }

    return true;
  }

  async componentWillLoad() {
    // Define lang attribute
    this.lang = assignLanguage(this.el);

    this.updateLang();

    const valid = this.validateRequiredProps();

    if (!valid) {
      logError('gcds-srvinfo', this.errors);
    }
  }

  private getColumnsValue(): string {
    if (this.columns === false) return "1fr";
    return "1fr 1fr 1fr";
  }

  private getTabletColumnsValue(): string {
    if (this.columns === false) {
      return "1fr";
    }
    return "1fr 1fr";
  }

  private get heading(): string {
    const lang = this.lang === 'fr' ? 'fr' : 'en';
    return i18n[lang].heading;
  }

  render() {
    const { items, headingVisible, serviceItems } = this;

    if (!this.validateRequiredProps()) {
      return null;
    }

    const validItems = Math.min(Math.max(1, items), 9);
    const displayItems = Array.isArray(serviceItems)
      ? serviceItems.slice(0, validItems)
      : [];

    const headingClass = headingVisible
      ? "font-size-h3 mt-400"
      : "font-size-h3 mt-400 visibility-sr-only";

    return (
      <Host>
        <gcds-container size="xl" tag="section" main-container centered>
          <h2 class={headingClass}>{this.heading}</h2>
          <gcds-grid
            columns="1"
            columns-tablet={this.getTabletColumnsValue()}
            columns-desktop={this.getColumnsValue()}
            class="mb-400 mt-400"
          >
            {displayItems.map((item: ServiceItem) => (
              <div>
                <gcds-link class="font-family-heading font-bold mt-0" href={item.linkHref}>
                  {item.linkText}
                </gcds-link>
                <p class="font-size-text-small lg:mb-200 xs:mb-0">{item.description}</p>
              </div>
            ))}
          </gcds-grid>
          <slot></slot>
        </gcds-container>
      </Host>
    );
  }
}
