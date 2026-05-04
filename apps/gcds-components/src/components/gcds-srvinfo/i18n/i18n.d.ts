interface I18NStrings {
  heading: string;
}

declare const I18N: {
  en: I18NStrings;
  fr: I18NStrings;
  [key: string]: I18NStrings;
};

export default I18N;
