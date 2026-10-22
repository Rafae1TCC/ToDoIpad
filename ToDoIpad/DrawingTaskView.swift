//
//  DrawingTaskView.swift
//  ToDoIpad
//
//  Created by Rafael Cabrera on 10/20/26.
//


import SwiftUI
import PencilKit

enum DrawingToolType: String, CaseIterable {
    case pen = "Pen"
    case marker = "Marker"
    case eraser = "Eraser"
}

struct DrawingCanvas: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    var tool: PKTool

    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.drawingPolicy = .anyInput
        canvas.overrideUserInterfaceStyle = .light
        canvas.backgroundColor = .white
        canvas.delegate = context.coordinator
        canvas.tool = tool
        return canvas
    }

    func updateUIView(_ canvas: PKCanvasView, context: Context) {
        canvas.tool = tool
        if canvas.drawing != drawing {
            canvas.drawing = drawing
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(drawing: $drawing)
    }

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var drawing: Binding<PKDrawing>

        init(drawing: Binding<PKDrawing>) {
            self.drawing = drawing
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            drawing.wrappedValue = canvasView.drawing
        }
    }
}

struct DrawingTaskView: View {
    @State private var drawing = PKDrawing()
    @State private var toolType: DrawingToolType = .pen
    @State private var color = Color.black
    @State private var width: Double = 5
    var onSave: (TaskItem) -> Void

    var currentTool: PKTool {
        switch toolType {
        case .pen:
            return PKInkingTool(.pen, color: UIColor(color), width: width)
        case .marker:
            return PKInkingTool(.marker, color: UIColor(color), width: width)
        case .eraser:
            return PKEraserTool(.bitmap)
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            Picker("Tool", selection: $toolType) {
                ForEach(DrawingToolType.allCases, id: \.self) { type in
                    Text(LocalizedStringKey(type.rawValue)).tag(type)
                }
            }
            .pickerStyle(.segmented)
            .accessibilityIdentifier("toolPicker")

            HStack(spacing: 16) {
                ColorPicker("Color", selection: $color)
                    .labelsHidden()
                    .accessibilityIdentifier("colorPicker")
                Slider(value: $width, in: 2...20)
                    .accessibilityIdentifier("widthSlider")
                Button("Undo") {
                    drawing = PKDrawing(strokes: Array(drawing.strokes.dropLast()))
                }
                .disabled(drawing.strokes.isEmpty)
                .accessibilityIdentifier("undoDrawingBtn")
                Button("Clear") {
                    drawing = PKDrawing()
                }
                .disabled(drawing.strokes.isEmpty)
                .accessibilityIdentifier("clearDrawingBtn")
            }

            DrawingCanvas(drawing: $drawing, tool: currentTool)
                .frame(maxWidth: 500)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray))
                .accessibilityIdentifier("drawingCanvas")

            Spacer()
        }
        .padding()
        .navigationTitle("Drawing Task")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    if let fileName = DrawingStorage.save(makeImage()) {
                        onSave(TaskItem(title: "", drawingFileName: fileName))
                    }
                }
                .disabled(drawing.strokes.isEmpty)
                .accessibilityIdentifier("saveDrawingTaskBtn")
            }
        }
    }

    func makeImage() -> UIImage {
        let rect = drawing.bounds.insetBy(dx: -10, dy: -10)
        var ink = UIImage()
        UITraitCollection(userInterfaceStyle: .light).performAsCurrent {
            ink = drawing.image(from: rect, scale: 2)
        }
        let renderer = UIGraphicsImageRenderer(size: ink.size)
        return renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: ink.size))
            ink.draw(at: .zero)
        }
    }
}
