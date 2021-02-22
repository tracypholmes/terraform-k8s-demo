# HWTH - Automating Deployments Walkthrough

Terraform uses providers to interface with various APIs and exposing resources. A provider is versioned and included as part of a configuration file.

```bash
provider "kubernetes" {
host = "[https://kubernetes:6443](https://kubernetes:6443/)"
}
```

The [Kubernetes Provider](https://www.terraform.io/docs/providers/kubernetes/index.html) allows Terraform to make calls to the [Kubernetes API](https://kubernetes.io/docs/concepts/overview/kubernetes-api/).

### **Initialize Terraform**

Terraform requires initialization before any configuration can be applied. Initialization:

1. Installs any required providers.
2. Creates the local state directory or connects to the remote state store.

In the **Editor** tab, review the `/root/terraform/provider.tf` file and examine the provider configuration. The Kubernetes provider configuration includes version and authentication parameters.

In the **Terraform** tab, check that you are in the `/root/terraform` folder.

`$ pwd
/root/terraform`

If not, change the folder to `/root/terraform`. This is where the Terraform files are located.

`$ cd /root/terraform`

Next, initialize Terraform in the **Terraform** terminal tab.

`terraform init`

This installs the Terraform Kubernetes provider and creates a `.terraform` directory for local state management.

When the provider has completed installation, hit **check** to continue.

Terraform allows a dry-run of changes and displays the differences. This is done through executing terraform plan.

For a full reference, see [CLI documentation](https://www.terraform.io/docs/commands/plan.html).

### **Plan the Deployment**

In the *Terraform* tab, run:

`terraform plan -out=nginx.tfplan`

It should output two changes and create a binary file called `nginx.tfplan`.

Hit **check** to continue.

Terraform uses graph theory to create and modify resources in the correct order.

For more information about the Terraform resource graph, see [this documentation](https://www.terraform.io/docs/internals/graph.html).

### **View the Graph**

Terraform uses graph theory to determine the order by which changes and resources can be applied and created.

If you would like to generate the graph locally, make sure you have Graphviz installed and then run this command:

`terraform graph | dot -Tsvg > graph.svg`

Alternately, you can run `terraform graph`. Copy the output and paste it into the browser at [GraphivizOnline](https://bit.ly/2S1NLCn).

What do you notice about the graph?

To apply the changes, use terraform apply. This command will execute on plan.

See the [CLI documentation](https://www.terraform.io/docs/cli/commands/apply.html) for more information.

### **Apply the Deployment**

In the **Terraform** tab, run:

`terraform apply`

This will apply the changes by deploying the nginx web server to the Kubernetes cluster.

In the **Kubernetes** tab, execute:

`kubectl get pods`

This should have a single Nginx pod running. To check the Nginx service, run:

`kubectl get service`

We are going to change the state backend to demonstrate the importance of configuring and maintaining a state file.

For more information about backend types, see [Terraform documentation](https://www.terraform.io/docs/backends/types/index.html).

### **Change the Backend**

Maintaining state for Terraform is critical to demonstrate and evaluate the differences in infrastructure configuration.

Let's change the backend state to demonstrate how we might configure a new backend. Before this step, we destroyed all of the previous infrastructure and state, so we start completely anew.

We're going to configure a `local` backend to point to a different file path, specifically `/tmp/terraform.tfstate`.

Open the **Editor** tab.

Open the `/root/terraform/provider.tf` file. It includes a section called `backend "local"`.

This directs the state file to `/tmp/terraform.tfstate`.

Go to the **Terraform** tab and run:

`terraform init
terraform apply`

You should be able to execute:

`ls -al /tmp`

and ensure there is a `terraform.tfstate` file in that directory.

Input variables parametrize Terraform modules. They can be passed through command line as `-var key=value` or added to a file and passed with `-var-file
filename.tfvars`.

For more information about input variables, see [Terraform documentation](https://www.terraform.io/docs/configuration/variables.html).

### **Update Variables**

In this example, variables will be updated in the `terraform.tfvars` file. By default, this file will contains values that override the default ones in the `variables.tf` file.

Go the **Editor** tab. In the `terraform.tfvars` file, update the `name=` and `replicas=` to the following:

`name="myapp"
replicas=3`

Note that the name is a string and must be in quotes.

Save the file by using Ctrl+S.

Next, go to the **Terraform** tab. Run:

`terraform apply`

Type "yes" to apply the changes. You should see it recreate many of the resources, including the name of the application and the number of replicas.

Hit **check** to complete the challenge.

You can destroy resources with Terraform as well. As long as they are in Terraform state, Terraform will clean up the resources.

For more information about Terraform and the `destroy` command, see [Terraform documentation](https://www.terraform.io/docs/commands/destroy.html).

### **Destroy Resources**

Finally, destroy the resources in the Kubernetes cluster.

You want to destroy the resources in order to clean up any unused infrastructure.

In the **Terraform** tab, type:

`$ terraform destroy`

Enter "yes" on the prompt to destroy the resources you've created in the Kubernetes cluster.

In the **Kubernetes** tab, you can type:

```bash
$ kubectl get pods
No resources found in default namespace.
$ kubectl get service
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   xx.xx.xx.xx   <none>        xx/TCP   xx
```

To see that the nginx pod and service has been removed.
