//
//  WMKMathKeyboard.m
//  Math Keeper
//
//  Created by Bill Wu on 7/3/17.
//  Copyright © 2017 William Wu. All rights reserved.
//

#import "WMKMathKeyboard.h"
#import "WMKMathKeyboardRootView.h"
#import <iosMath/MTFontManager.h>
#import <iosMath/MTMathAtomFactory.h>

@implementation WMKMathKeyboard

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.isLatinAlphabet = YES;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // initialization
    }
    return self;
}

- (BOOL)enableInputClicksWhenVisible {
    return YES;
}

#pragma mark - Key press handlers

- (IBAction)keyPressed:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    NSString *text = [NSString stringWithString:sender.currentTitle];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""]; // remove spaces
    [self.textView insertText:text];
}

- (IBAction)fractionPressed:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [self.textView insertText:MTSymbolFractionSlash];
}

- (IBAction)exponentPressed:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [self.textView insertText:@"^"];
}

- (IBAction)squareRootPressed:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [self.textView insertText:MTSymbolSquareRoot];
}

- (IBAction)rootWithDegreePressed:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [self.textView insertText:MTSymbolCubeRoot];
}

- (IBAction)absoluteValuePressed:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [self.textView insertText:@"||"];
}

- (IBAction)logWithBasePressed:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [self.textView insertText:@"log"];
    [self.textView insertText:@"_"];
}

- (IBAction)subscriptPressed:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    [self.textView insertText:@"_"];
}

- (IBAction)greekLatinPressed:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    if (self.isLatinAlphabet) { // switch to Greek alphabet
        for (UIButton *button in self.letters) {
            switch (button.tag) {
                case 0: // q -> hidden
                    [button setHidden:YES];
                    break;
                case 1: // w -> alpha
                    [button setTitle:@"\u03b1" forState:UIControlStateNormal];
                    break;
                case 2: // e -> beta
                    [button setTitle:@"\u03b2" forState:UIControlStateNormal];
                    break;
                case 3: // r -> gamma
                    [button setTitle:@"\u03b3" forState:UIControlStateNormal];
                    break;
                case 4: // t -> delta
                    [button setTitle:@"\u03b4" forState:UIControlStateNormal];
                    break;
                case 5: // y -> epsilon
                    [button setTitle:@"\u03b5" forState:UIControlStateNormal];
                    break;
                case 6: // u -> zeta
                    [button setTitle:@"\u03b6" forState:UIControlStateNormal];
                    break;
                case 7: // i -> eta
                    [button setTitle:@"\u03b7" forState:UIControlStateNormal];
                    break;
                case 8: // o -> theta
                    [button setTitle:@"\u03b8" forState:UIControlStateNormal];
                    break;
                case 9: // p -> hidden
                    [button setHidden:YES];
                    break;
                case 10: // a -> iota
                    [button setTitle:@"\u03b9" forState:UIControlStateNormal];
                    break;
                case 11: // s -> kappa
                    [button setTitle:@"\u03ba" forState:UIControlStateNormal];
                    break;
                case 12: // d -> lambda
                    [button setTitle:@"\u03bb" forState:UIControlStateNormal];
                    break;
                case 13: // f -> mu
                    [button setTitle:@"\u03bc" forState:UIControlStateNormal];
                    break;
                case 14: // g -> nu
                    [button setTitle:@"\u03bd" forState:UIControlStateNormal];
                    break;
                case 15: // h -> xi
                    [button setTitle:@"\u03be" forState:UIControlStateNormal];
                    break;
                case 16: // j -> omicron
                    [button setTitle:@"\u03bf" forState:UIControlStateNormal];
                    break;
                case 17: // k -> pi
                    [button setTitle:@"\u03c0" forState:UIControlStateNormal];
                    break;
                case 18: // l -> rho
                    [button setTitle:@"\u03c1" forState:UIControlStateNormal];
                    break;
                case 19: // z -> sigma
                    [button setTitle:@"\u03c3" forState:UIControlStateNormal];
                    break;
                case 20: // x -> tau
                    [button setTitle:@"\u03c4" forState:UIControlStateNormal];
                    break;
                case 21: // c -> upsilon
                    [button setTitle:@"\u03c5" forState:UIControlStateNormal];
                    break;
                case 22: // v -> phi
                    [button setTitle:@"\u03c6" forState:UIControlStateNormal];
                    break;
                case 23: // b -> chi
                    [button setTitle:@"\u03c7" forState:UIControlStateNormal];
                    break;
                case 24: // n -> psi
                    [button setTitle:@"\u03c8" forState:UIControlStateNormal];
                    break;
                case 25: // m -> omega
                    [button setTitle:@"\u03c9" forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            [sender setTitle:@"abcd" forState:UIControlStateNormal];
            self.isLatinAlphabet = NO;
        }
    }
    else { // switch to Latin alphabet
        for (UIButton *button in self.letters) {
            switch (button.tag) {
                case 0: // hidden -> q
                    [button setHidden:NO];
                    break;
                case 1: // // alpha -> w
                    [button setTitle:@"w" forState:UIControlStateNormal];
                    break;
                case 2: // beta -> e
                    [button setTitle:@"e" forState:UIControlStateNormal];
                    break;
                case 3: // gamma -> r
                    [button setTitle:@"r" forState:UIControlStateNormal];
                    break;
                case 4: // delta -> t
                    [button setTitle:@"t" forState:UIControlStateNormal];
                    break;
                case 5: // epsilon -> y
                    [button setTitle:@"y" forState:UIControlStateNormal];
                    break;
                case 6: // zeta -> u
                    [button setTitle:@"u" forState:UIControlStateNormal];
                    break;
                case 7: // eta -> i
                    [button setTitle:@"i" forState:UIControlStateNormal];
                    break;
                case 8: // theta -> o
                    [button setTitle:@"o" forState:UIControlStateNormal];
                    break;
                case 9: // hidden -> p
                    [button setHidden:NO];
                    break;
                case 10: // iota -> a
                    [button setTitle:@"a" forState:UIControlStateNormal];
                    break;
                case 11: // kappa -> s
                    [button setTitle:@"s" forState:UIControlStateNormal];
                    break;
                case 12: // lambda -> d
                    [button setTitle:@"d" forState:UIControlStateNormal];
                    break;
                case 13: // mu -> f
                    [button setTitle:@"f" forState:UIControlStateNormal];
                    break;
                case 14: // nu -> g
                    [button setTitle:@"g" forState:UIControlStateNormal];
                    break;
                case 15: // xi -> h
                    [button setTitle:@"h" forState:UIControlStateNormal];
                    break;
                case 16: // omicron -> j
                    [button setTitle:@"j" forState:UIControlStateNormal];
                    break;
                case 17: // pi -> k
                    [button setTitle:@"k" forState:UIControlStateNormal];
                    break;
                case 18: // rho -> l
                    [button setTitle:@"l" forState:UIControlStateNormal];
                    break;
                case 19: // sigma -> z
                    [button setTitle:@"z" forState:UIControlStateNormal];
                    break;
                case 20: // tau -> x
                    [button setTitle:@"x" forState:UIControlStateNormal];
                    break;
                case 21: // upsilon -> c
                    [button setTitle:@"c" forState:UIControlStateNormal];
                    break;
                case 22: // phi -> v
                    [button setTitle:@"v" forState:UIControlStateNormal];
                    break;
                case 23: // chi -> b
                    [button setTitle:@"b" forState:UIControlStateNormal];
                    break;
                case 24: // psi -> n
                    [button setTitle:@"n" forState:UIControlStateNormal];
                    break;
                case 25: // omega -> m
                    [button setTitle:@"m" forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            [sender setTitle:@"\u03b1\u03b2\u03b3\u03b4" forState:UIControlStateNormal];
            self.isLatinAlphabet = YES;
        }
    }
    if ([WMKMathKeyboardRootView sharedInstance].isLowerCase) {
        [self shiftDown];
    }
    else {
        [self shiftUp];
    }
}

#pragma mark - Keyboard case toggle

- (void)shiftDown {
    // change letters to lowercase
    for (UIButton *button in self.letters) {
        NSString *newTitle = [button.titleLabel.text lowercaseString];
        [button setTitle:newTitle forState:UIControlStateNormal];
    }
    
    // change alternate keys
    [self.decimalButton setTitle:@"." forState:UIControlStateNormal];
    self.decimalAltLabel.text = @",";
    [self.timesButton setTitle:@"\u00d7" forState:UIControlStateNormal];
    self.timesAltLabel.text = @"\u22c5";
    [self.plusMinusButton setTitle:@"\u00b1" forState:UIControlStateNormal];
    self.plusMinusAltLabel.text = @"\u2213";
}

- (void)shiftUp {
    // change letters to uppercase
    for (UIButton *button in self.letters) {
        NSString *newTitle = [button.titleLabel.text uppercaseString];
        [button setTitle:newTitle forState:UIControlStateNormal];
    }
    
    // change alternate keys
    [self.decimalButton setTitle:@"," forState:UIControlStateNormal];
    self.decimalAltLabel.text = @".";
    [self.timesButton setTitle:@"\u22c5" forState:UIControlStateNormal];
    self.timesAltLabel.text = @"\u00d7";
    [self.plusMinusButton setTitle:@"\u2213" forState:UIControlStateNormal];
    self.plusMinusAltLabel.text = @"\u00b1";
}

#pragma mark -

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

@end
