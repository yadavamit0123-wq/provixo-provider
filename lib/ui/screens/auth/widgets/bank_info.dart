import '../../../../app/generalImports.dart';

class Form6BankInfo extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final GlobalKey<CustomFieldsFormState> customFieldsKey;
  final Map<String, dynamic>? customFieldsLocalValues;

  const Form6BankInfo({
    super.key,
    required this.formKey,
    required this.customFieldsKey,
    this.customFieldsLocalValues,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            BlocBuilder<GetCustomFieldsCubit, GetCustomFieldsState>(
              builder: (context, state) {
                if (state is GetCustomFieldsInProgress) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CustomCircularProgressIndicator()),
                  );
                } else if (state is GetCustomFieldsSuccess) {
                  final fields = state.fields
                      .where((f) => f.fieldGroup == 'bank_details')
                      .toList();
                  if (fields.isEmpty) return const SizedBox.shrink();

                  return CustomFieldsForm(
                    key: customFieldsKey,
                    fields: fields,
                    initialValues: {
                      ...state.savedValues,
                      if (customFieldsLocalValues != null)
                        ...customFieldsLocalValues!,
                    },
                  );
                } else if (state is GetCustomFieldsFail) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ErrorContainer(
                      errorMessage: state.error,
                      showErrorImage: false,
                      errorMessageFontSize: 12,
                      onTapRetry: () {
                        context
                            .read<GetCustomFieldsCubit>()
                            .fetchCustomFields();
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
