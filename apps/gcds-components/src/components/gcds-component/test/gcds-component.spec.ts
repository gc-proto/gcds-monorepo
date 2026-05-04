import { newSpecPage } from '@stencil/core/testing';
import { GcdsComponent } from '../gcds-component';

describe('gcds-component', () => {
  it('renders', async () => {
    const page = await newSpecPage({
      components: [GcdsComponent],
      html: '<gcds-component></gcds-component>',
    });
    expect(page.root).toEqualHtml(`
      <gcds-component>
        <mock:shadow-root>
          <div>
            Hello, World! I'm
          </div>
        </mock:shadow-root>
      </gcds-component>
    `);
  });

  it('renders with values', async () => {
    const page = await newSpecPage({
      components: [GcdsComponent],
      html: `<gcds-component first="Stencil" middle="'Don't call me a framework'" last="JS"></gcds-component>`,
    });
    expect(page.root).toEqualHtml(`
      <gcds-component first="Stencil" middle="'Don't call me a framework'" last="JS">
        <mock:shadow-root>
          <div>
            Hello, World! I'm Stencil 'Don't call me a framework' JS
          </div>
        </mock:shadow-root>
      </gcds-component>
    `);
  });
});
