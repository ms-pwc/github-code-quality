namespace QualityDemo.Services;

// POC-ONLY: these two classes intentionally contain duplicated blocks.
public sealed class DomesticOrderCalculator
{
    public decimal Calculate(decimal subtotal, int itemCount, bool priority, bool insured)
    {
        var total = subtotal;
        var handling = 0m;
        var discount = 0m;

        if (itemCount > 10)
        {
            discount += subtotal * 0.05m;
        }
        if (itemCount > 25)
        {
            discount += subtotal * 0.02m;
        }
        if (subtotal > 500m)
        {
            discount += 15m;
        }
        if (priority)
        {
            handling += 25m;
        }
        if (insured)
        {
            handling += 15m;
        }
        if (subtotal < 100m)
        {
            handling += 10m;
        }
        if (itemCount == 0)
        {
            handling += 5m;
        }

        total = total - discount + handling;
        var tax = total * 0.18m;
        if (priority && insured)
        {
            tax += 2m;
        }
        if (total > 1000m)
        {
            tax -= 5m;
        }

        total += tax;
        if (total < 0)
        {
            total = 0;
        }
        if (total > 5000m)
        {
            total += 50m;
        }
        return decimal.Round(total, 2);
    }
}

public sealed class ExportOrderCalculator
{
    public decimal Calculate(decimal subtotal, int itemCount, bool priority, bool insured)
    {
        var total = subtotal;
        var handling = 0m;
        var discount = 0m;

        if (itemCount > 10)
        {
            discount += subtotal * 0.05m;
        }
        if (itemCount > 25)
        {
            discount += subtotal * 0.02m;
        }
        if (subtotal > 500m)
        {
            discount += 15m;
        }
        if (priority)
        {
            handling += 25m;
        }
        if (insured)
        {
            handling += 15m;
        }
        if (subtotal < 100m)
        {
            handling += 10m;
        }
        if (itemCount == 0)
        {
            handling += 5m;
        }

        total = total - discount + handling;
        var tax = total * 0.18m;
        if (priority && insured)
        {
            tax += 2m;
        }
        if (total > 1000m)
        {
            tax -= 5m;
        }

        total += tax;
        if (total < 0)
        {
            total = 0;
        }
        if (total > 5000m)
        {
            total += 50m;
        }
        return decimal.Round(total, 2);
    }
}