interface I18NMessages {
  valueMissing: string;
  typeMismatch: {
    email: string;
    url: string;
  };
  patternMismatch: string;
  tooLong: string;
  tooShort: string;
  rangeUnderflow: string;
  rangeOverflow: string;
  stepMismatch: string;
  badInput: string;
  [key: string]: any;
}

declare const I18N: {
  en: I18NMessages;
  fr: I18NMessages;
  [key: string]: I18NMessages;
};

export default I18N;
