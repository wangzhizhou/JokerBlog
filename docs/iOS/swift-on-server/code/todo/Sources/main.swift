import Kitura

let controller = Controller()

Kitura.addHTTPServer(onPort:controller.port, with: controller.router)

Kitura.run()
