namespace QualityDemo.Services;

// POC-ONLY: these two classes intentionally contain duplicated blocks.
public sealed class DomesticOrderCalculator
{
    public decimal Calculate(decimal subtotal, int itemCount, bool priority, bool insured)
    {
        var total = subtotal;
        if (itemCount > 10)
        {
            total -= subtotal * 0.05m;
        }
        if (priority)
        {
            total += 25m;
        }
        if (insured)
        {
            total += 15m;
        }
        if (total < 0)
        {
            total = 0;
        }
        return decimal.Round(total, 2);
    }
}

public sealed class ExportOrderCalculator
{
    public decimal Calculate(decimal subtotal, int itemCount, bool priority, bool insured)
    {
        var total = subtotal;
        if (itemCount > 10)
        {
            total -= subtotal * 0.05m;
        }
        if (priority)
        {
            total += 25m;
        }
        if (insured)
        {
            total += 15m;
        }
        if (total < 0)
        {
            total = 0;
        }
        return decimal.Round(total, 2);
    }
}