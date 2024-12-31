#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

// Define la clave para almacenar la preferencia del usuario en NSUserDefaults
#define DontShowAlertAgain @"KEY_12345"

// Función para redimensionar imágenes manteniendo la escala original
UIImage* resizeImage(UIImage *image, CGSize newSize) {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, image.scale);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

// Función para descargar y guardar imágenes en el directorio Documents/qximages/
// Esta función se ejecuta al inicio de la aplicación
void downloadAndSaveImages() {
    // URLs de las imágenes a descargar
    NSString *qxImageURL = @"https://raw.githubusercontent.com/QxAngel/libQxAngelToolsTJ/main/qximages/qx.png";
    NSString *igImageURL = @"https://raw.githubusercontent.com/QxAngel/libQxAngelToolsTJ/main/qximages/ig.png";
    NSString *ppImageURL = @"https://raw.githubusercontent.com/QxAngel/libQxAngelToolsTJ/main/qximages/pp.png";

    // Obtener la ruta del directorio Documents y crear la subcarpeta qximages
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *qxImagesPath = [documentsDirectory stringByAppendingPathComponent:@"qximages"];

    // Crear el directorio qximages si no existe
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:qxImagesPath]) {
        NSError *error;
        if ([fileManager createDirectoryAtPath:qxImagesPath withIntermediateDirectories:YES attributes:nil error:&error]) {
        }
    }

    // Configuración de las imágenes a descargar
    NSArray *imageInfos = @[
        @{@"url": qxImageURL, @"name": @"qx.png"},
        @{@"url": igImageURL, @"name": @"ig.png"},
        @{@"url": ppImageURL, @"name": @"pp.png"}
    ];

    // Procesar cada imagen
    for (NSDictionary *imageInfo in imageInfos) {
        NSString *imageURL = imageInfo[@"url"];
        NSString *imagePath = [qxImagesPath stringByAppendingPathComponent:imageInfo[@"name"]];
        
        // Descargar solo si la imagen no existe localmente
        if (![fileManager fileExistsAtPath:imagePath]) {
            NSURL *url = [NSURL URLWithString:imageURL];
            
            if (!url) {
                continue;
            }
            
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
            
            NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                if (error == nil) {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    
                    if (httpResponse.statusCode == 200) {
                        NSError *moveError;
                        if ([[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:imagePath] error:&moveError]) {
                        }
                    }
                }
            }];
            
            [downloadTask resume];
        }
    }
}

// Función principal que muestra el alert
void QxAlert() {
    // Verificar si el usuario ha elegido no mostrar el alert nuevamente
    if (![[NSUserDefaults standardUserDefaults] boolForKey:DontShowAlertAgain]) {
        // Obtener la ruta de las imágenes almacenadas
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths firstObject];
        NSString *qxImagesPath = [documentsDirectory stringByAppendingPathComponent:@"qximages"];

        // Cargar las imágenes desde el almacenamiento local
        UIImage *qxImage = [UIImage imageWithContentsOfFile:[qxImagesPath stringByAppendingPathComponent:@"qx.png"]];
        UIImage *igImage = [UIImage imageWithContentsOfFile:[qxImagesPath stringByAppendingPathComponent:@"ig.png"]];
        UIImage *ppImage = [UIImage imageWithContentsOfFile:[qxImagesPath stringByAppendingPathComponent:@"pp.png"]];

        // Redimensionar las imágenes a 30x30 píxeles
        UIImage *resizedQxImage = resizeImage(qxImage, CGSizeMake(30, 30));
        UIImage *resizedIgImage = resizeImage(igImage, CGSizeMake(30, 30));
        UIImage *resizedPpImage = resizeImage(ppImage, CGSizeMake(30, 30));

        // Determinar el estilo del alert según el dispositivo
        UIAlertControllerStyle alertStyle = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) 
            ? UIAlertControllerStyleActionSheet  // Para iPhone
            : UIAlertControllerStyleAlert;       // Para iPad

        // Crear el UIAlertController con título y mensaje
        UIAlertController *view = [UIAlertController alertControllerWithTitle:@"Hello World"
                                                                     message:@"This is a UIAlertController"
                                                              preferredStyle:alertStyle];

        // Botón "Website" con color amarillo
        UIAlertAction* website = [UIAlertAction actionWithTitle:@"iPA Library"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           NSURL *url = [NSURL URLWithString:@"https://qxangel.github.io"];
                                                           if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                                               [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                                                           }
                                                           [view dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        [website setValue:[UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0] forKey:@"titleTextColor"];

        // Botón "Instagram" con color rosa
        UIAlertAction* instagram = [UIAlertAction actionWithTitle:@"Instagram"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            NSURL *url = [NSURL URLWithString:@"https://www.instagram.com/6ky_l/"];
                                                            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                                                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                                                            }
                                                            [view dismissViewControllerAnimated:YES completion:nil];
                                                        }];
        [instagram setValue:[UIColor colorWithRed:0.9 green:0.1 blue:0.6 alpha:1.0] forKey:@"titleTextColor"];

        // Botón "PayPal" con color azul
        UIAlertAction* paypal = [UIAlertAction actionWithTitle:@"Paypal"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          NSURL *url = [NSURL URLWithString:@"https://www.paypal.me/onlykex1"];
                                                          if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                                              [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                                                          }
                                                          [view dismissViewControllerAnimated:YES completion:nil];
                                                      }];
        [paypal setValue:[UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0] forKey:@"titleTextColor"];

        // Botón "Don't Show Again" con color naranja
        UIAlertAction* dontShowAgain = [UIAlertAction actionWithTitle:@"Don't Show Again"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action) {
                                                                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:DontShowAlertAgain];
                                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                                [view dismissViewControllerAnimated:YES completion:nil];
                                                            }];
        [dontShowAgain setValue:[UIColor colorWithRed:1.0 green:0.6 blue:0.0 alpha:1.0] forKey:@"titleTextColor"];

        // Agregar todas las acciones al alert
        [view addAction:website];
        [view addAction:instagram];
        [view addAction:paypal];
        [view addAction:dontShowAgain];

        // Botón "Done" con estilo de cancelación y color rojo
        UIAlertAction* done = [UIAlertAction actionWithTitle:@"Done"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action) {
                                                       [view dismissViewControllerAnimated:YES completion:nil];
                                                   }];
        [done setValue:[UIColor redColor] forKey:@"titleTextColor"];
        [view addAction:done];

        // Asignar las imágenes redimensionadas a los botones
        [website setValue:[resizedQxImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
        [instagram setValue:[resizedIgImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
        [paypal setValue:[resizedPpImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];

        // Obtener el view controller principal y mostrar el alert
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        UIViewController *rootViewController = keyWindow.rootViewController;
        [rootViewController presentViewController:view animated:YES completion:nil];
    }
}

// Función de inicialización que se ejecuta automáticamente al cargar la librería
__attribute__((constructor))
static void init() {
    // Iniciar la descarga de imágenes
    downloadAndSaveImages();

    // ***NOTA: Si las imágenes no se descargan o no se cargan localmente,
    // el alert se mostrará con los botones normales sin imágenes. ***

    // Mostrar el alert después de un retraso de 4 segundos
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        QxAlert();
    });
}