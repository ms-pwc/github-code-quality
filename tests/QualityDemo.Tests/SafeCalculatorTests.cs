using QualityDemo.Services;
using Xunit;

namespace QualityDemo.Tests;

public sealed class SafeCalculatorTests
{
    private readonly SafeCalculator _calculator = new();

    [Fact]
    public void Add_ReturnsSum()
    {
        Assert.Equal(7, _calculator.Add(3, 4));
    }

    [Fact]
    public void Subtract_ReturnsDifference()
    {
        Assert.Equal(5, _calculator.Subtract(8, 3));
    }

    [Theory]
    [InlineData(2, true)]
    [InlineData(3, false)]
    public void IsEven_ReturnsExpectedResult(int value, bool expected)
    {
        Assert.Equal(expected, _calculator.IsEven(value));
    }

    [Fact]
    public void Percentage_WithZeroWhole_Throws()
    {
        Assert.Throws<DivideByZeroException>(() => _calculator.Percentage(1, 0));
    }

    [Fact]
    public void Percentage_ReturnsPercentage()
    {
        Assert.Equal(25m, _calculator.Percentage(1, 4));
    }
}