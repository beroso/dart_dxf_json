bool parseBoolean(String str) {
  if (str == '0') return false;
  if (str == '1') return true;
  throw ArgumentError.value(str);
}

Object parseGroupValue(int code, String value) {
  return switch (code) {
    <= 9 => value,
    >= 10 && <= 59 => double.parse(value.trim()),
    >= 60 && <= 99 => int.parse(value.trim()),
    >= 100 && <= 109 => value,
    >= 110 && <= 149 => double.parse(value.trim()),
    >= 160 && <= 179 => int.parse(value.trim()),
    >= 210 && <= 239 => double.parse(value.trim()),
    >= 270 && <= 289 => int.parse(value.trim()),
    >= 290 && <= 299 => parseBoolean(value.trim()),
    >= 300 && <= 369 => value,
    >= 370 && <= 389 => int.parse(value.trim()),
    >= 390 && <= 399 => value,
    >= 400 && <= 409 => int.parse(value.trim()),
    >= 410 && <= 419 => value,
    >= 420 && <= 429 => int.parse(value.trim()),
    >= 430 && <= 439 => value,
    >= 440 && <= 459 => int.parse(value.trim()),
    >= 460 && <= 469 => double.parse(value.trim()),
    >= 470 && <= 481 => value,
    == 999 => value,
    >= 1000 && <= 1009 => value,
    >= 1010 && <= 1059 => double.parse(value.trim()),
    >= 1060 && <= 1071 => int.parse(value.trim()),
    _ => throw ArgumentError('Group code does not have a defined type: ${{
        'code': code,
        'value': value
      }}'),
  };
}
