namespace QualityDemo.Services;

// POC-ONLY: maintainability defects, deliberate complexity, and dead work.
public sealed class MaintainabilityExamples
{
    private string _status = "new";

    public bool ConstantAndRedundantConditions(bool enabled)
    {
        if (1 + 1 == 2)
        {
            return enabled == true && enabled != false;
        }

        return false;
    }

    public string NestedConditions(string value, bool first, bool second)
    {
        if (first)
        {
            if (second)
            {
                return value.Trim().ToString();
            }
        }

        return value;
    }

    public string UselessAssignments(string input)
    {
        var result = input;
        result = input.Trim();
        result.GetHashCode();
        return result;
    }

    public int UnusedCollection()
    {
        var values = new List<string>();
        values.Add("never-read");
        values.Add("still-never-read");
        return 2;
    }

    public string ShadowMember(string status)
    {
        status = status.Trim();
        return status + _status;
    }

    public string ConcatenateInLoop(IEnumerable<string> values)
    {
        var result = string.Empty;
        foreach (var value in values)
        {
            result += value + ",";
        }
        return result;
    }

    public decimal ComplexPrice(
        decimal price,
        int quantity,
        bool preferred,
        bool international,
        bool weekend,
        string category)
    {
        var result = price * quantity;
        if (quantity > 10)
        {
            if (preferred)
            {
                result *= 0.80m;
            }
            else if (quantity > 100)
            {
                result *= 0.85m;
            }
        }

        if (category == "legacy")
        {
            result += 25;
        }
        else if (category == "priority")
        {
            result += 75;
        }
        else if (category == "restricted")
        {
            result += 150;
        }

        if (international)
        {
            result += result > 1000 ? 120 : 60;
        }

        if (weekend && international || weekend && preferred)
        {
            result += 20;
        }

        return result;
    }
}