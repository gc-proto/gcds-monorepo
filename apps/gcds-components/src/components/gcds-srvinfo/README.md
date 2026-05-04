# gcds-srvinfo



<!-- Auto Generated Below -->


## Overview

The Service and Information component provides links to commonly used services and information.

## Properties

| Property         | Attribute         | Description                                                                                                    | Type                      | Default |
| ---------------- | ----------------- | -------------------------------------------------------------------------------------------------------------- | ------------------------- | ------- |
| `banded`         | `banded`          | Apply banding background to the section                                                                        | `boolean`                 | `false` |
| `columns`        | `columns`         | Number of columns for desktop layout (1 or 3)                                                                  | `boolean`                 | `true`  |
| `headingVisible` | `heading-visible` | Whether to show the heading                                                                                    | `boolean`                 | `false` |
| `items`          | `items`           | Number of service items to display (1-9)                                                                       | `number`                  | `9`     |
| `serviceItems`   | `service-items`   | Array of service items with linkText, linkHref, and description. Accepts an array of objects or a JSON string. | `ServiceItem[] \| string` | `'[]'`  |


## Slots

| Slot        | Description              |
| ----------- | ------------------------ |
| `"default"` | Slot for doormat content |


----------------------------------------------

*Built with [StencilJS](https://stenciljs.com/)*
