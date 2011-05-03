# TTTArrayFormatter
## Convert lists into sentences or symbol-delimited strings

Think of this as a production-ready alternative to `NSArray -componentsJoinedByString:`. `TTTArrayFormatter` comes with internationalization baked-in, and provides a concise API that allows you to configure for any edge cases.

## Example Usage

Drop `TTTOrdinalNumberFormatter.{h,m}` in your project, include it in your class, and use it like so:

  NSArray *list = [NSArray arrayWithObjects:@"Russel", @"Spinoza", @"Rawls", nil];
  TTTArrayFormatter *arrayFormatter = [[[TTTArrayFormatter alloc] init] autorelease];
  [arrayFormatter setUsesAbbreviatedConjunction:YES]; // Use '&' instead of 'and'
  [arrayFormatter setUsesSerialDelimiter:NO]; // Omit Oxford Comma
  NSLog(@"%@", [arrayFormatter stringFromArray:list]); // # => "Russell, Spinoza & Rawls"


Although `TTTOrdinalNumberFormatter` is internationalized, there are some edge cases that require manual configuration to localize correctly. For instance, lists in Japanese can be delimited by the particles 'と' and 'や', depending on whether the list is exclusive or inclusive. To accommodate this, you could localize the `ja` string entry for @"List conjunction" to @"" and do:

  NSArray *list = [NSArray arrayWithObjects:@"マグロ", @"ウナギ", @"サバ", @"タコ", nil];
  TTTArrayFormatter *arrayFormatter = [[[TTTArrayFormatter alloc] init] autorelease];
  [arrayFormatter setDelimiter:@"や"]; // Use inclusive list particle
  NSLog(@"%@", [arrayFormatter stringFromArray:list]); // # => "マグロやウナギやサバやタコ"


## License

TTTArrayFormatter is licensed under the MIT License:

  Copyright (c) 2011 Mattt Thompson (http://mattt.me/)

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
