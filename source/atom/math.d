module atom.math;
import std.traits;

R FromRangeToRange(T, R)(T value, T oldMin, T oldMax, R newMin, R newMax) if (isNumeric!T && isNumeric!R)
{
    auto oldRange = (oldMax - oldMin);
    auto newRange = (newMax - newMin);
    auto newValue = cast(R) (((value - oldMin) * newRange) / oldRange) + newMin;

    return newValue;
}