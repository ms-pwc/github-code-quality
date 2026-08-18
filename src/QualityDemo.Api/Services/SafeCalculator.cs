namespace QualityDemo.Services;

public sealed class SafeCalculator
{
    public int Add(int left, int right) => checked(left + right);

    public int Subtract(int left, int right) => checked(left - right);

    public bool IsEven(int value) => value % 2 == 0;

    public decimal Percentage(decimal part, decimal whole)
    {
        if (whole == 0)
        {
            throw new DivideByZeroException("The whole value must not be zero.");
        }

        return part / whole * 100;
    }
}