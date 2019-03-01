
#import "RegularExpression.h"

@implementation RegularExpression

#pragma mark 判断银行卡号是否合法
+ (BOOL)isBankCard:(NSString *)bankNumber {
    if(bankNumber.length==0){
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < bankNumber.length; i++){
        c = [bankNumber characterAtIndex:i];
        if (isdigit(c)){
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--){
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo){
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}

+(BOOL)isPhoneNumber:(NSString *)patternStr{
    
    NSString *pattern = @"^1[34578]\\d{9}$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+(BOOL)detectionIsEmailQualified:(NSString *)patternStr{
    
    NSString *pattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+(BOOL)detectionIsIdCardNumberQualified:(NSString *)patternStr{
    NSString *pattern = @"^\\d{15}|\\d{18}$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+(BOOL)detectionIsPasswordQualified:(NSString *)patternStr{
    NSString *pattern = @"^[a-zA-Z]\\w.{5,17}$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+ (BOOL)detectionIsIPAddress:(NSString *)patternStr
{

    NSString *pattern = @"((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+(BOOL)detectionIsAllNumber:(NSString *)patternStr{
    NSString *pattern = @"^[0-9]*$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+(BOOL)detectionIsEnglishAlphabet:(NSString *)patternStr{
    NSString *pattern = @"^[A-Za-z]+$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+(BOOL)detectionIsUrl:(NSString *)patternStr{
    NSString *pattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}
+(BOOL)detectionIsChinese:(NSString *)patternStr{
    NSString *pattern = @"[\u4e00-\u9fa5]+";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:patternStr options:0 range:NSMakeRange(0, patternStr.length)];
    return results.count > 0;
}

+(BOOL)detectionNormalText:(NSString *)normalStr WithHighLightText:(NSString *)HighLightStr{
    
    NSString *pattern = [NSString stringWithFormat:@"%@",HighLightStr];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:normalStr options:0 range:NSMakeRange(0, normalStr.length)];
    for (NSTextCheckingResult *resltText in results) {
        HLLog(@"----------------%zd",resltText.range.length);
    }
    return results.count > 0;
}

/**< BOOL类型非0为真,0为假 */
+ (BOOL)checkUserName:(NSString *)userName {
    NSString *regex   = @"(^[A-Za-z0-9]{3,20}$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:userName];
}

+ (BOOL)checkPassword:(NSString *)password {
    NSString *regex   = @"(^[A-Za-z0-9]{6,20}$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:password];
}

+ (BOOL)checkEmail:(NSString *)email {
    NSString *regex   = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:email];
}

+ (BOOL)checkURL:(NSString *)url {
    NSString *regex   = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:url];
}

+ (BOOL)checkTelephoneNumber:(NSString *)telephoneNumber {
    NSString *MOBILE             = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString *CM                 = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString *CU                 = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString *CT                 = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSString *PHS                = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm     = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu     = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct     = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs    = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    return [regextestmobile evaluateWithObject:telephoneNumber] || [regextestphs evaluateWithObject:telephoneNumber] || [regextestct evaluateWithObject:telephoneNumber] || [regextestcu evaluateWithObject:telephoneNumber] || [regextestcm evaluateWithObject:telephoneNumber];
}




//验证是否不为空
+ (BOOL)verifyIsNotEmpty:(NSString *)str {
    if (!str) return NO;
    
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![str isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

//正则验证
//+ (BOOL)verifyText:(NSString *)text withRegex:(NSString *)regex
//{
//    return [[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isMatchedByRegex:regex];
//}

//验证身份证
//必须满足以下规则
//1. 长度必须是18位，前17位必须是数字，第十八位可以是数字或X
//2. 前两位必须是以下情形中的一种：11,12,13,14,15,21,22,23,31,32,33,34,35,36,37,41,42,43,44,45,46,50,51,52,53,54,61,62,63,64,65,71,81,82,91
//3. 第7到第14位出生年月日。第7到第10位为出生年份；11到12位表示月份，范围为01-12；13到14位为合法的日期
//4. 第17位表示性别，双数表示女，单数表示男
//5. 第18位为前17位的校验位
//算法如下：
//（1）校验和 = (n1 + n11) * 7 + (n2 + n12) * 9 + (n3 + n13) * 10 + (n4 + n14) * 5 + (n5 + n15) * 8 + (n6 + n16) * 4 + (n7 + n17) * 2 + n8 + n9 * 6 + n10 * 3，其中n数值，表示第几位的数字
//（2）余数 ＝ 校验和 % 11
//（3）如果余数为0，校验位应为1，余数为1到10校验位应为字符串“0X98765432”(不包括分号)的第余数位的值（比如余数等于3，校验位应为9）
//6. 出生年份的前两位必须是19或20
+ (BOOL)isIDCardNumber:(NSString *)ID {
    ID = [ID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([ID length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:ID]) {
        return NO;
    }
    int summary = ([ID substringWithRange:NSMakeRange(0,1)].intValue + [ID substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([ID substringWithRange:NSMakeRange(1,1)].intValue + [ID substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([ID substringWithRange:NSMakeRange(2,1)].intValue + [ID substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([ID substringWithRange:NSMakeRange(3,1)].intValue + [ID substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([ID substringWithRange:NSMakeRange(4,1)].intValue + [ID substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([ID substringWithRange:NSMakeRange(5,1)].intValue + [ID substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([ID substringWithRange:NSMakeRange(6,1)].intValue + [ID substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [ID substringWithRange:NSMakeRange(7,1)].intValue *1 + [ID substringWithRange:NSMakeRange(8,1)].intValue *6
    + [ID substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    return [checkBit isEqualToString:[[ID substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}

//身份证号
+ (BOOL)isIDCard:(NSString *)ID {
    BOOL flag;
    if (ID.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *IDPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    return [IDPredicate evaluateWithObject:ID];
}

@end
