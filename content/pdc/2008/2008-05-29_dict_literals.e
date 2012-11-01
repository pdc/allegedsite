Title: Dictionary Literals in C#
Icon: ../icon-64x64.png
Date: 2008-05-29
Topics: csharp python

C# Does not have a nice way to represent a dictionary as a single value: you can only
create an empty dictionary and add entries one by one. Which is annoyingly verbose if you
are used to a more reasonable programming language,

In Python if I want to have a look-up table of keywords it looks like this:

    keyword_formats = {
        'addAddress': 'Add address %s',
        'removeAddress': 'Remove address %s',
        'globalWhitelist': 'because it is the global whitelist',
        'globalBlacklist': 'because it is the global blacklist',
        'messageWhitelist': 'because it is in the message whitelist',
        'messageBlacklist': 'because it is in the message blacklist',
    }

Not counting whitespace, that's 39 characters of overhead.

But I need this in C# not Python. it suddenly came to me that  I could get a similar effect with this code:

    static readonly Dictionary<string, string> keywordFormats = (delegate() {
        Dictionary<string, string> result = new Dictionary<string, string>();
        result["addAddress"] = "Add address {0}";
        result["removeAddress"] = "Remove address {0}";
        result["globalWhitelist"] = "because it is the global whitelist";
        result["globalBlacklist"] = "because it is the global blacklist";
        result["messageWhitelist"] = "because it is in the message whitelist";
        result["messageBlacklist"] = "because it is in the message blacklist";
        return result;
    })();

thats 215 characters overhead, I think. (I am not going to bother counting twice.)

The use of 

    delegate () {...}()

to disguise a block as an expression is an idiom in JavaScript, and I expected it to also
work in C#. But, alas! it appears that anonymous method definitions are forbidden in static
initializers. At least the compiler would not permit this usage: it complains that I am
trying to define a delegate with no name, which suggests its parser is confusing my use of
an anonymous method with a delegate-type definition.

In C# it seems like our only option is to define a static constructor that assigns a value to the static field `keywordFormats`, or define a named method replacing the anonymous one:

    static readonly Dictionary<string, string> keywordFormats 
        = GetKeywordFormats();
    static Dictionary<string, string> GetKeywordFormats() {
        Dictionary<string, string> result = new Dictionary<string, string>();
        result["addAddress"] = "Add address {0}";
        result["removeAddress"] = "Remove address {0}";
        result["globalWhitelist"] = "because it is the global whitelist";
        result["globalBlacklist"] = "because it is the global blacklist";
        result["messageWhitelist"] = "because it is in the message whitelist";
        result["messageBlacklist"] = "because it is in the message blacklist";
        return result;
    }

Note that in this verison I have to type the expression `Dictionary<string, string>` a fourth time, and I have to invent a name for the new static function that is used only once.

I wonder if C# 3 has a better way to do this?