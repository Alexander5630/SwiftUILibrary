import SwiftUI

struct Product: Identifiable {
    let id: Int
    let name: String
    let price: Double
    let image: String
}

struct ContentView: View {
    
    let products = [
        Product(id: 0, name: "Breaking Bad", price: 100, image: "https://media.themoviedb.org/t/p/w600_and_h900_bestv2/ztkUQFLlC19CCMYHW9o1zWhJRNq.jpg"),
        Product(id: 1, name: "House", price: 200, image: "https://media.themoviedb.org/t/p/w300_and_h450_bestv2/3Cz7ySOQJmqiuTdrc6CY0r65yDI.jpg"),
        Product(id: 2, name: "My Fault", price: 300, image: "https://media.themoviedb.org/t/p/w300_and_h450_bestv2/w46Vw536HwNnEzOa7J24YH9DPRS.jpg"),
        Product(id: 3, name: "The Boys", price: 400, image: "https://media.themoviedb.org/t/p/w300_and_h450_bestv2/2zmTngn1tYC1AvfnrFLhxeD82hz.jpg"),
        Product(id: 4, name: "Kingdom of the Planet of the Apes", price: 500, image: "https://media.themoviedb.org/t/p/w300_and_h450_bestv2/gKkl37BQuKTanygYQG1pyYgLVgf.jpg")
    ]
    
    let colors: [Color] = [.red, .green, .blue]
    
    @Namespace var animation
    @State private var shouldAnimate = false
    @State private var selectedProduct: Product?
    
    var body: some View {
        VStack {
            if shouldAnimate, let selectedProduct {
                CartDetail(animation: animation, product: selectedProduct)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            shouldAnimate.toggle()
                        }
                    }
            } else {
                ScrollViewReader { value in
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(products, id: \.id) { product in
                                Cart(animation: animation, product: product)
                                    .frame(width: 250, height: 400)
                                    .onTapGesture {
                                        selectedProduct = product
                                        withAnimation(.spring()) {
                                            shouldAnimate.toggle()
                                        }
                                    }
                                    .id(product.id)
                            }
                        }
                    }
                    .onAppear() {
                        print("onAppear")
                        value.scrollTo(selectedProduct?.id, anchor: .center)
                    }
                }
            }
        }
    }
}


struct Cart: View {
    
    var animation: Namespace.ID
    var product: Product
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: product.image)){ phase in
                switch phase {
                case .failure:
                    Image(systemName: "photo")
                        .font(.largeTitle)
                case .success(let image):
                    image
                        .resizable()
                default:
                    ProgressView()
                }
            }
            .matchedGeometryEffect(id: product.image, in: animation)
            .foregroundStyle(.white)
            VStack {
                Spacer()
                Text(product.name)
                    .matchedGeometryEffect(id: product.name, in: animation)
                    .font(.caption)
                    .foregroundStyle(.white)
            }
            .padding(.vertical, 10)
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .background(.gray)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct CartDetail: View {
    
    var animation: Namespace.ID
    var product: Product
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: product.image)){ phase in
                switch phase {
                case .failure:
                    Image(systemName: "photo")
                        .font(.largeTitle)
                case .success(let image):
                    image
                        .resizable()
                default:
                    ProgressView()
                }
            }
            .matchedGeometryEffect(id: product.image, in: animation)
            .foregroundStyle(.white)
            Text(product.name)
                .font(.title)
                .matchedGeometryEffect(id: product.name, in: animation)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
    }
}
