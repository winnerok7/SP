#pragma once
extern "C"
{
	void Mult_192x192_LONGOP(long* dest, long* pB, long* pA);
	void Mult_Nx32_LONGOP(long bits, long* dest, long* pB, long* pA);
	void Add_LONGOP(long bits, long* dest, long* pB, long* pA);
	void Sub_LONGOP(long bits, long* dest, long* pB, long* pA);
}