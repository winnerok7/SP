// lab11.cpp : ���������� ����� ����� ��� ����������.
//

#include "stdafx.h"
#include "lab11.h"
#include "vectsse.h"
#include "vectfpu.h"
#include "stdio.h"

#define MAX_LOADSTRING 100

void vectorFPU(HWND hWnd);
void vectorSSE(HWND hWnd);
void vectorCpp(HWND hWnd);

// ���������� ����������:
HINSTANCE hInst;                                // ������� ���������
WCHAR szTitle[MAX_LOADSTRING];                  // ����� ������ ���������
WCHAR szWindowClass[MAX_LOADSTRING];            // ��� ������ �������� ����

// ��������� ���������� �������, ���������� � ���� ������ ����:
ATOM                MyRegisterClass(HINSTANCE hInstance);
BOOL                InitInstance(HINSTANCE, int);
LRESULT CALLBACK    WndProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK    About(HWND, UINT, WPARAM, LPARAM);

int APIENTRY wWinMain(_In_ HINSTANCE hInstance,
	_In_opt_ HINSTANCE hPrevInstance,
	_In_ LPWSTR    lpCmdLine,
	_In_ int       nCmdShow)
{
	UNREFERENCED_PARAMETER(hPrevInstance);
	UNREFERENCED_PARAMETER(lpCmdLine);

	// TODO: ���������� ��� �����.

	// ������������� ���������� �����
	LoadStringW(hInstance, IDS_APP_TITLE, szTitle, MAX_LOADSTRING);
	LoadStringW(hInstance, IDC_LAB11, szWindowClass, MAX_LOADSTRING);
	MyRegisterClass(hInstance);

	// ��������� ������������� ����������:
	if (!InitInstance(hInstance, nCmdShow))
	{
		return FALSE;
	}

	HACCEL hAccelTable = LoadAccelerators(hInstance, MAKEINTRESOURCE(IDC_LAB11));

	MSG msg;

	// ���� ��������� ���������:
	while (GetMessage(&msg, nullptr, 0, 0))
	{
		if (!TranslateAccelerator(msg.hwnd, hAccelTable, &msg))
		{
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
	}

	return (int)msg.wParam;
}



//
//  �������: MyRegisterClass()
//
//  ����: ������������ ����� ����.
//
ATOM MyRegisterClass(HINSTANCE hInstance)
{
	WNDCLASSEXW wcex;

	wcex.cbSize = sizeof(WNDCLASSEX);

	wcex.style = CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc = WndProc;
	wcex.cbClsExtra = 0;
	wcex.cbWndExtra = 0;
	wcex.hInstance = hInstance;
	wcex.hIcon = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_LAB11));
	wcex.hCursor = LoadCursor(nullptr, IDC_ARROW);
	wcex.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
	wcex.lpszMenuName = MAKEINTRESOURCEW(IDC_LAB11);
	wcex.lpszClassName = szWindowClass;
	wcex.hIconSm = LoadIcon(wcex.hInstance, MAKEINTRESOURCE(IDI_SMALL));

	return RegisterClassExW(&wcex);
}

//
//   �������: InitInstance(HINSTANCE, int)
//
//   ����: ��������� ������ ���������� � ������� ������� ����
//
//   �����������:
//
//        � ���� ������� ������ ���������� ����������� � ���������� ����������, � �����
//        ��������� � ��������� ������� ���� ���������.
//
BOOL InitInstance(HINSTANCE hInstance, int nCmdShow)
{
	hInst = hInstance; // ��������� ������ ���������� � ���������� ����������

	HWND hWnd = CreateWindowW(szWindowClass, szTitle, WS_OVERLAPPEDWINDOW,
		CW_USEDEFAULT, 0, CW_USEDEFAULT, 0, nullptr, nullptr, hInstance, nullptr);

	if (!hWnd)
	{
		return FALSE;
	}

	ShowWindow(hWnd, nCmdShow);
	UpdateWindow(hWnd);

	return TRUE;
}

//
//  �������: WndProc(HWND, UINT, WPARAM, LPARAM)
//
//  ����: ������������ ��������� � ������� ����.
//
//  WM_COMMAND  - ���������� ���� ����������
//  WM_PAINT    - ��������� �������� ����
//  WM_DESTROY  - ��������� ��������� � ������ � ���������
//
//
LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
	case WM_COMMAND:
	{
		int wmId = LOWORD(wParam);
		// ��������� ����� � ����:
		switch (wmId)
		{
		case IDM_ABOUT:
			DialogBox(hInst, MAKEINTRESOURCE(IDD_ABOUTBOX), hWnd, About);
			break;
		case IDM_EXIT:
			DestroyWindow(hWnd);
			break;
		case ID_32771:
			vectorFPU(hWnd);
			break;
		case ID_32772:
			vectorSSE(hWnd);
			break;
		case ID_32773:
			vectorCpp(hWnd);
			break;
		default:
			return DefWindowProc(hWnd, message, wParam, lParam);
		}
	}
	break;
	case WM_PAINT:
	{
		PAINTSTRUCT ps;
		HDC hdc = BeginPaint(hWnd, &ps);
		// TODO: �������� ���� ����� ��� ����������, ������������ HDC...
		EndPaint(hWnd, &ps);
	}
	break;
	case WM_DESTROY:
		PostQuitMessage(0);
		break;
	default:
		return DefWindowProc(hWnd, message, wParam, lParam);
	}
	return 0;
}

// ���������� ��������� ��� ���� "� ���������".
INT_PTR CALLBACK About(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	switch (message)
	{
	case WM_INITDIALOG:
		return (INT_PTR)TRUE;

	case WM_COMMAND:
		if (LOWORD(wParam) == IDOK || LOWORD(wParam) == IDCANCEL)
		{
			EndDialog(hDlg, LOWORD(wParam));
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}

__declspec(align(16)) float oA[320];
__declspec(align(16)) float oB[320];
__declspec(align(16)) float res;
__declspec(align(16)) float res_sse[4];
__declspec(align(16)) float res_avx[8];
__declspec(align(16)) char TextBuf[320];

void init()
{
	float a = 1.0;
	float b = 52.0;
	for (int i = 0; i < 320; i++)
	{
		oA[i] = a;
		a = a + 0.1f;
		oB[i] = b;
		b = b - 0.1f;
	}
}

float MyDotProduct(float* A, float* B, long N)
{
	float r = 0;
	for (long i = 0; i < N; i++)
	{
		r += A[i] * B[i];
	}
	return r;
}

void vectorCpp(HWND hWnd)
{
	init();
	SYSTEMTIME st;
	long tst, ten;
	GetLocalTime(&st);

	tst = 60000 * (long)st.wMinute
		+ 1000 * (long)st.wSecond
		+ (long)st.wMilliseconds;
	for (long i = 0; i < 1000000; i++)
	{
		res = MyDotProduct(oA, oB, 320);
	}
	GetLocalTime(&st);
	ten = 60000 * (long)st.wMinute
		+ 1000 * (long)st.wSecond
		+ (long)st.wMilliseconds - tst;
	sprintf_s(TextBuf, "��������� ������� = % f\n��� ��������� = % ld ��", res, ten);
	MessageBox(hWnd, TextBuf, "C++", MB_OK);
}

void vectorSSE(HWND hWnd)
{
	init();
	SYSTEMTIME st;
	long tst, ten;
	GetLocalTime(&st);
	tst = 60000 * (long)st.wMinute
		+ 1000 * (long)st.wSecond
		+ (long)st.wMilliseconds;
	for (long i = 0; i < 1000000; i++)
	{
		MyDotProduct_SSE(res_sse, oA, oB, 320);
	}
	GetLocalTime(&st);
	ten = 60000 * (long)st.wMinute
		+ 1000 * (long)st.wSecond
		+ (long)st.wMilliseconds - tst;
	sprintf_s(TextBuf, "��������� ������� = % f\n��� ��������� = % ld ��", res_sse[0], ten);
	MessageBox(hWnd, TextBuf, "SSE", MB_OK);
}

void vectorFPU(HWND hWnd)
{
	init();
	SYSTEMTIME st;
	long tst, ten;
	GetLocalTime(&st);
	tst = 60000 * (long)st.wMinute
		+ 1000 * (long)st.wSecond
		+ (long)st.wMilliseconds;
	for (long i = 0; i < 1000000; i++)
	{
		MyDotProduct_FPU(&res, oA, oB, 320);
	}
	GetLocalTime(&st);
	ten = 60000 * (long)st.wMinute
		+ 1000 * (long)st.wSecond
		+ (long)st.wMilliseconds - tst;

	sprintf_s(TextBuf, "��������� ������� = % f\n��� ��������� = % ld ��", res, ten);
	MessageBox(hWnd, TextBuf, "FPU", MB_OK);
}