
.data
    arraysize DQ 0
    iterator DQ 0
    iterator_input DQ 0
    width2 DQ 0
    border_detector DQ 0
    highThreshold DQ 150
    lowThreshold DQ 50

    kernel:
        DW 1, 1, 2, 4, 2, 2, 2, 1, 1
        ; our kerenl is:
        ; 1, 2, 1,
        ; 2, 4, 2,
        ; 1, 2, 1
        ; but data that we insert into regsiters is not in correct order

.code

;RCX -> arraysize
;RDI -> width
;R8 -> red_input
;R9 -> green_input
;RSP+40 -> blue_input
;RSP+48 -> red_output
;RSP+56 -> green_output
;RSP+64 -> blue_output

;R13 -> width but in bytes, so RDI*2
;R14 -> current color input ptr
;R12 -> current color output ptr

; Function to calculate the gradient magnitude of a pixel
; Inputs:
;   - R8: Red component of the pixel
;   - R9: Green component of the pixel
;   - RSP+40: Blue component of the pixel
; Outputs:
;   - RAX: Gradient magnitude of the pixel

gradMagnitude proc
    mov rax, 0

    ; Calculate the squared magnitude of the gradient
    movd xmm0, dword ptr[R8] ; red component
    vmulps xmm0, xmm0, xmm0 ; square the red component
    movd xmm1, dword ptr[R9] ; green component
    vmulps xmm1, xmm1, xmm1 ; square the green component
    addps xmm0, xmm1 ; add the squared red and green components
    movd xmm1, dword ptr[RSP+40] ; blue component
    vmulps xmm1, xmm1, xmm1 ; square the blue component
    addps xmm0, xmm1 ; add the squared blue component

    ; Calculate the gradient magnitude
    vsqrtss xmm0, xmm0 ; square root of the squared magnitude

    ret
gradMagnitude endp

; Function to apply hysteresis thresholding to a pixel
; Inputs:
;   - RAX: Gradient magnitude of the pixel
; Outputs:
;   - R8: Edge flag (0 for non-edge, 1 for edge)

hysteresisThresholding proc
    mov r8, 0 ; initialize edge flag to 0

    cmp rax, highThreshold ; compare gradient magnitude to high threshold
    jge EdgeDetected

    cmp rax, lowThreshold ; compare gradient magnitude to low threshold
    jl Continue

    ; Check if there is an edge in the surrounding pixels
    mov r9, 1 ; offset to check surrounding pixels
    mov rdi, rsi ; save current row pointer

    LoopCheckSurroundingPixels:
        mov rsi, rdi ; restore current row pointer
        add rsi, r9 ; move to the next pixel
        cmp rsi, rdx ; check if we're out of bounds
        jl ContinueLoopCheckSurroundingPixels
        jl Continue

        gradMagnitude

        mov rax, r8 ; check if the surrounding pixel is an edge
        jne ContinueLoopCheckSurroundingPixels

        EdgeDetected:
            mov r8, 1 ; set edge flag to 1

        ContinueLoopCheckSurroundingPixels:
            add r9, 2 ; move to the next pixel
            loop LoopCheckSurroundingPixels

Continue:
    ret
hysteresisThresholding endp

; Function to detect edges using the Canny edge detection algorithm
; Inputs:
;   - RCX: Size of the input image (in pixels)
;   - RDI: Width of the input image (in pixels)
;   - R8: Pointer to the red component of the input image
;   - R9: Pointer to the green component of the input image
;   - RSP+40: Pointer to the blue component of the input image
; Outputs:
;   - RSP+48: Pointer to the red component of the output image
;   - RSP+56: Pointer to the green component of the output image
;   - RSP+64: Pointer to the blue component of the output image

cannyEdgeDetection proc

    mov r13, rdi           ; Save width in bytes for later use
    mov r14, r8            ; Save the starting address of red input
    mov r12, rdx           ; Save the starting address of red output

    mov rcx, arraysize     ; Set loop counter to the size of the input image

    LoopProcessPixels:
        ; Calculate the memory offsets for the current pixel
        imul rdx, rcx, 2     ; Multiply loop counter by 2 to get current offset
        mov rsi, r14         ; Current color input pointer (red)
        add rsi, rdx         ; Move to the current pixel
        mov r15, rsi         ; Save the pointer to the current pixel

        ; Calculate the gradient magnitude
        gradMagnitude

        ; Apply hysteresis thresholding
        hysteresisThresholding

        ; Store the result in the output arrays
        mov word ptr[r12 + rdx], ax ; Red component
        mov word ptr[r12 + r13 + rdx], ax ; Green component
        mov word ptr[r12 + 2 * r13 + rdx], ax ; Blue component

        ; Move to the next pixel
        inc rcx             ; Decrement loop counter
        jnz LoopProcessPixels ; Continue loop if counter is not zero

    ret
cannyEdgeDetection endp

